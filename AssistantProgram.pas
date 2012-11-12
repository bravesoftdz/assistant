{**
@Abstract Assistant main class
@Author Prof1983 <prof1983@ya.ru>
@Created 14.07.2007
@LastMod 12.11.2012
}
unit AssistantProgram;

interface

uses
  IniFiles, SysUtils,
  ABase, AConsts2, ALogFileText, AMessageEvent, AMessageEventX, AProgramImpl, ASystemData, ATypes,
  AiChatAgentImpl, AiConsts, AiCoreImpl, AiInterpretatorImpl, AiReasonAgentImpl, AiReasonerModule,
  ArMessages,
  AilTokenizer,
  AssistantEngine, AssistantEnviromentObj, AssistantGlobals, AssistantModule, AssistantReason,
  AssistantSystem, ModuleInfoRec;

type //** ������� ����� ��������� Assistant
  TAssistantProgram = class(TAProgram)
  private
    {** ��������� ������� ����������� ������� � �� }
    procedure CheckKB();
    {** ������� ������������� ���� }
    procedure CreateInterpretator();
    {** �������������� �������� ������ }
    //procedure CreateKnowlegeBase();
    {** ������� �������� ������ ���������� ������ }
    procedure CreateReasonAgent();
    {** ���������������� ����� ChatAgent }
    procedure InitChatAgent();
    {** ���������������� ������ ���-��������� � ���� }
    procedure InitLog();
    {** ������� ������ ����������� ������ �� ������ ��������� OWL }
    procedure InitReasoner();
  protected
    {** ����������� ��� �������� ������� }
    procedure DoCreate(); override;
    {** ����������� ��� ����������� ������� }
    procedure DoDestroy(); override;
    function DoInitialize(): TProfError; override;
    {** ����������� ����� �������� ����������� }
    function DoStart(): WordBool; override;
    {** ����������� ����� �������� ������� ��������� (�������) }
    function DoStarted(): WordBool; override;
  public
    function GetModuleByIndex(Index: Integer): TAssistantModule;
    function GetModuleByLocalId(LocalId: Integer): TAssistantModule;
    function GetModuleCount(): Integer;
    function GetSendMessageEvent(): TProfMessageEvent;
  public
    //function AddMessage(const AMsg: WideString): AInt; override;
    {** ��������� ��� �������� �������� �������� }
    function AddMessageA(Msg: AMessage): Integer; virtual;
    {** �������� DLL ������ }
    function AddModule(Module: TAssistantModule): Integer;
    function NewModule(FileName: WideString): TAssistantModule;
  public
    {** ��������� ��������� ������������� ������� ����� OnMessage }
    function SendMessage(const Msg: WideString): Integer; override;
    {** ��������� ��������� ������������� ������� ����� OnMessageA }
    function SendMessageA(Msg: AMessage): Integer; virtual;
    {** ���������� ��������� ������������� ������� ����� OnMessage }
    function SendStrMessage(const Msg: WideString): Integer;
  public
    {** ��������� DLL ������ }
    procedure LoadModules();
    {** ��������� ���� }
    function RunFile(FileName: WideString): Boolean;
    {** ��������� ������ }
    function RunScript(Code: WideString): Boolean;
    {** ��������� ��������� ����� }
    function RunSystemMethod(ClassName, MethodName, Param: WideString): Boolean;
  public
    {** ����������� ��� ������������������ ������� }
    function Finalize(): AError; override;
    {** �������������� ��� ����������� ������� }
    function Initialize(): AError; override;
  public
    class function GetInstance(): TAssistantProgram;
  public
    constructor Create();
  public
    (*
    property LogFileName: WideString read FLogFileName write FLogFileName;
    {** ���� ��������� ��� ������ }
    property Messages: TArMessages read FMessages;
    {** CallBack ������� �������� ��������� }
    property OnMessageA: TProcMessageA read FOnMessageA write FOnMessageA;
    *)
    property SendMessageEvent: TProfMessageEvent read GetSendMessageEvent;
    //** ����������� DLL �������
    property ModuleCount: Integer read GetModuleCount;
    //** DLL ������ �� �������
    property ModuleByIndex[Index: Integer]: TAssistantModule read GetModuleByIndex;
    //** DLL ������ �� ID
    property ModuleByLocalID[LocalID: Integer]: TAssistantModule read GetModuleByLocalID;
  end;

{** ���������� ��������� ������� }
function AssistantProgram_GetCore(): TAiCore;
{** �������������� ��������� }
function AssistantProgram_Initialize(): AError;

resourcestring // ��������� ----------------------------------------------------
  stInitializeConnectionError = '���������� � ����� �� ����������������';
  stInitializeConnectionOk = '���������� � ����� ����������������';
  stInitializeConnectionStart = '������������� ���������� � �����';
  stInitializeEventsError = '������� �� ����������������';
  stInitializeEventsOk = '������� ����������������';
  stInitializeEventsStart = '������������� �������';
resourcestring
  INIT_KNOWLEGE_BASE = '�������������� �������� ������';
  INIT_REASON_AGENT = '������� �������� ������ ���������� ������';
  INIT_SETTINGS = '������� ������ ������ � ����������� ���������';
resourcestring
  NoModulesMessage = '�� ������� �� ������ ������.'#13#10+
        '��������� ��������� ���������, ��������� ������� DLL ������� '+
        '(������ DLL ������ ������������� � ����� modules).'#13#10+
        '�������������� ���������� �������� � ������������ � �� ����� aikernel.org';
  IniFileDefault =
    '; ���� �������� assistant.ini ��� ������� Assistant'#13#10+
    '; Prof1983 <prof1983@ya.ru>'#13#10+
    #13#10+
    '; ������ � ��������� �����������'#13#10+
    '[General]'#13#10+
    '; ��� ����� ������-����������'#13#10+
    'BootModule = ' + BootModuleDefaultFileName + #13#10 +
    #13#10;

implementation

uses
  fStart;

var
  {** ��������� ������� }
  FCore: TAiCore;
  FLogFileName: WideString;
  FMessages: TArMessages;
  {** CallBack ������� �������� ��������� }
  FOnMessageA: TProcMessageA;
  FSendMessageEvent: TProfMessageEvent;
  FSendMessageEventX: TProfMessageEventX;
  {** ����� ���-��� }
  FChatAgent: TAiChatAgent;
  {** ������������� ���� �� ����� AR }
  FInterpretator: TAiInterpretator;
  {** ������� ������ ���������� ������ }
  FReasonAgent: TAiReasonAgent;
  {** ������ ����������� ������ �� ������ ��������� OWL }
  FReasoner: TAiReasonerModule;
  {** ������ Assitant }
  FEngine: TAssistantEngine;
  {** DLL ������ ������� }
  FModules: array of TAssistantModule;
  {** ������� ����� }
  FReason: TReason;
  {** Assistant system }
  FSystem: TAssistantSystem;

function SystemProc(Sender, Receiver, Cmd, Param1, Param2: Integer): Integer; stdcall;
var
  i: Integer;
  i2: Integer;
  p: TAssistantProgram;
begin
  p := TAssistantProgram.GetInstance();

  //MainForm.LogRichEdit.Lines.Add(IntToStr(Sender)+' '+IntToStr(Receiver)+' '+
  //  IntToStr(Cmd)+' '+IntToStr(Param1)+' '+IntToStr(Param2));

  if (Receiver = AssistantGlobals.MainModuleLoacalID) then
    case Cmd of
      AssistantGlobals.GetModuleListCount: // Param1 - ��������� �� ���������� Int32
        begin
          Integer(Pointer(Param1)^) := p.ModuleCount;
        end;
      AssistantGlobals.GetModuleList: // Param1 - ��������� �� ������� ������ array[0..count-1]; Param2 - count
        begin
          if p.ModuleCount > Param2 then
            i2 := Param2
          else
            i2 := p.ModuleCount;
          for i := 0 to i2 - 1 do
            Integer(Pointer(Param1 + i * 4)^) := p.ModuleByIndex[i].Handle;
        end;
      AssistantGlobals.GetModuleInfo: // Param1 - LocalID ������, Param2 - PModuleInfo2
        begin
          p.ModuleByLocalID[Param1].ToModuleInfo2(TModuleInfo2(Pointer(Param2)^));
          // ...
        end;
    end;

  Result := 0;
end;

// --- Public ---

function AssistantProgram_GetCore(): TAiCore;
begin
  Result := FCore;
end;

function AssistantProgram_Initialize(): AError;
var
  IniFile: TIniFile;
  S: string;
  FileName: string;
  P: TAssistantProgram;
begin
  P := TAssistantProgram.GetInstance();

  TStartForm.AddToLog('�������������...');
  FCore := TAiCore.Create();

  P.Initialize();

  FSystem := TAssistantSystem.Create();
  // ������ ��������� �� ���������
  FSystem.BootModuleFileName := AssistantGlobals.BootModuleDefaultFileName;
  FSystem.ConfigurationDir := AssistantGlobals.ConfigurationDefaultDir; //'configuration';
  FSystem.ModulesDir := ModulesDefaultDir;

  S := ParamStr(1);
  if (S <> '') then
  begin
    FileName := S;
    S := ExtractFilePath(S);
    if (S = '') then
      FileName := FExePath + FileName;
  end;

  if (FileName = '') then
  begin
    FileName := FExePath + 'Assistant.ini';
    if not(FileExists(FileName)) then
      FileName := FConfigPath + 'Assistant.ini';
  end;

  if FileExists(FileName) then
  begin
    IniFile := TIniFile.Create(FileName);
    // ������ ���������
    FSystem.BootModuleFileName := IniFile.ReadString('General', 'BootModule', FSystem.BootModuleFileName);
    // ���������� ������������
    FSystem.ConfigurationDir  := IniFile.ReadString('General', 'Configuration', FSystem.ConfigurationDir);
    IniFile.Free();
  end;

  TStartForm.AddToLog('�������� DLL �������...');
  // ��������� DLL ������
  P.LoadModules();

  TStartForm.AddToLog('������������� ������ (Engine)');
  FEngine := TAssistantEngine.Create();
  FEngine.Initialize();

  TStartForm.AddToLog('������������� �������� ������');
  FReason := TReason.Create();
  FEngine.Enviroment.AddComponent(FReason);

  // ����� ����������������, ���� ����������� ��������� ������ �������.
  {if Length(FModules) = 0 then
  begin
    ShowMessage(NoModulesMessage);
    Halt(1);
  end;}
  Result := 0;
end;

{ TAssistantProgram }

(*function TAssistantProgram.AddMessage(const AMsg: WideString): Integer;
var
  x: AXmlNode;
  content: AXmlNode;
  i: Integer;
  m: WideString;
begin
  {SendMessage( //ACL_PREFIX + ACL + CRLF +
    ACL_SENDER + ':' + 'Core' + CRLF +
    ACL_CONTENT + ':' + '' + CRLF);}

  m := ARL_PREFIX + ARL + ' ' + ARL_ASSISTANT_FORM + ' ' + ARL_CORE + ' ' + ARL_CMD_CORE_GET_MODULES;

  if (AMsg = m) then
  begin
    X := AXmlNode_New0();
    AXmlNode_SetName(X, 'acl');
    //x.ChildNodes.New(ACL_SENDER).Value := ARL_CORE;
    //x.ChildNodes.New(ACL_RECEIVER).Value := ARL_ASSISTANT_FORM;
    //x.ChildNodes.New(ACL_PERFORMATIVE).Value := ACL_Ansswer;
    content := AXmlNode_GetChildNodeByName(X, ACL_CONTENT);
    //content.ChildNodes.New('Core');
    for i := 0 to FRuntime.ModuleCount - 1 do
      AXmlNode_GetChildNodeByName(X, FRuntime.GetModuleLocalNameByIndex(i));
    Result := Self.SendMessageX(X);
  end
  else
  begin
    //Result := FCore.AddMessage(AMsg);
  end;
end;*)

function TAssistantProgram.AddMessageA(Msg: AMessage): Integer;
begin
  Result := 0;
end;

function TAssistantProgram.AddModule(Module: TAssistantModule): Integer;
begin
  Result := Length(FModules);
  SetLength(FModules, Result + 1);
  FModules[Result] := Module;
end;

procedure TAssistantProgram.CheckKB();
var
  idAsistantClass: AId;  // ID ������ ��������� ARAsistant
begin
  idAsistantClass := 0;
  // ��������� ������� � �� ������ � ��������� ARAsistant
  if (idAsistantClass = 0) then
  begin
    // ������� ����� ��������� ARAsistant
    idAsistantClass := FCore.KnowledgeBase.NewFrame();
  end;
  if idAsistantClass = 0 then
  begin
    AddToLog(lgDataBase, ltError, '����� ������ ��������� ARAssitant �� ������');
    Exit;
  end;
  // ...

  // ��������� ������� � �� ������ �� ���� ��������� ARAsistant
  // ...
end;

constructor TAssistantProgram.Create();
begin
  // -- Default settings --
  Self.FConfigDir := AiConfigDir;
  Self.FDataDir := AiDataDir;
  Self.FProgramDescription := 'Personal assistant';
  Self.FProgramName := 'Assistant';
  Self.FProgramNameDisplay := 'Assistant';
  Self.FProgramVersionStr := '0.0';
  Self.FSystemName := 'AReason';

  Self.FConfigDir := AiConfigDir;
  Self.FDataDir := AiDataDir;

  inherited Create();

  FSendMessageEvent := TProfMessageEvent.Create(0, 'SendMessage');
  FSendMessageEventX := TProfMessageEventX.Create(0, 'SendMessageX');

  // ������� ������������ ���������
  {if not(Assigned(FConfigDocument)) then
  try
    FConfigDocument := TConfigDocument.Create(Self.ExePath + AiConfigDir + PathDelim + Self.ProgramName + '.' + FILE_EXT_CONFIG, AddToLog);
  except
  end;}

  if not(Assigned(FMessages)) then
  try
    FMessages := TArMessages.Create();
  except
    FMessages := nil;
  end;
end;

(*procedure TAssistantProgram.CreateAsistantAgent();
begin
  // ������� ������ Asistant
  FAssistantAgent := TAiAssistantAgent.Create();
  // ������ �������������
  FAssistantAgent.Interpretator := FInterpretator;
  // ������ ��� �� ����� AR
//  FAssistantAgent.CodeString := FKnowlegeBase.Frames.FreimStringByID[2];
  // ������ ������� ��� �����������
  FAssistantAgent.OnAddToLog := AddToLog;
  // ������ ������� ��� ������ ���������
  FAssistantAgent.OnSendMessageToCore := Self.SendStrMessage;
  // ������ ������� ��� ���������� ������
//  FAsistantAgent.OnCommand := DoCommand;
  // ���� ����������� ��������� � ���������
  //FAsistantAgent.Ping('�������� ���������');

  // TODO: ��������� ������ � ������ �������
  FCore.Agents.Add(FAssistantAgent);
  //FAgents.Add(FAsistantAgent);
end;*)

procedure TAssistantProgram.CreateInterpretator();
begin
  // ������� ������������� ����
  FInterpretator := TAiInterpretator.Create();
  FInterpretator.OnAddToLog := AddToLog;
end;

procedure TAssistantProgram.CreateReasonAgent();
begin
  AddToLog(lgNone, ltInformation, INIT_REASON_AGENT);
  FReasonAgent := TAiReasonAgent.Create();
  // ������ ������� ������ ���-���������
  FReasonAgent.OnAddToLog := AddToLog;
  // ������ ������� ������ ���������
  FReasonAgent.OnSendMessageToCore := SendStrMessage;
  // ������ ���-�������
  FReasonAgent.LogPrefix := '  ';
  // ������ �������� ������
  FReasonAgent.Pool := FCore.KnowledgeBase;
  // ������ ID ������ ������
//  FReasonAgent.ID := FSettings.ReasonID;
  // �������������� ������� ������
  FReasonAgent.Initialize();

  FCore.Agents.Add(FReasonAgent);
end;

procedure TAssistantProgram.DoCreate();
begin
  Self.FIsComServer := False;
  inherited DoCreate();
  // ������� ��������� ���� ���������
  FCore := TAiCore.Create();
  IInterface(FCore)._AddRef();
  //FCore.OnSendMessage := Self.SendMessageEvent.Run;
  //FCore.OnSendMessageX := Self.SendMessageEventX.Run;
  //FCore.Initialize();

  // ������� ������ ����������� ������ �� ������ ��������� OWL
  InitReasoner();

  FReasoner := TAiReasonerModule.Create();
end;

procedure TAssistantProgram.DoDestroy();
begin
  if Assigned(FMessages) then
  try
    FMessages.Free();
  finally
    FMessages := nil;
  end;
  inherited DoDestroy();
end;

function TAssistantProgram.DoInitialize(): TProfError;
begin
  Result := inherited DoInitialize();
  InitLog();
  AddToLog(lgGeneral, ltInformation, '=');
  AddToLog(lgGeneral, ltInformation, '������������� ���������');
end;

function TAssistantProgram.DoStart(): WordBool;
begin
  // �������� ���������� ���� �������� ������ ���������� ������
  FReasonAgent.Start();
end;

function TAssistantProgram.DoStarted(): WordBool;
begin
  AddToLog(lgGeneral, ltInformation, stInitializeConnectionStart);
  Result := inherited DoStarted();
end;

function TAssistantProgram.Finalize(): AError;
var
  Res: AError;
begin
  Res := inherited Finalize();

  if Assigned(FCore) then
  try
    try
      IInterface(FCore)._Release();
    finally
      FCore := nil;
    end;
  except
  end;

  if Assigned(FReasoner) then
  try
    try
      IINterface(FReasoner)._Release();
    finally
      FReasoner := nil;
    end;
  except
  end;

  if Assigned(FChatAgent) then
  try
    try
      IInterface(FChatAgent)._Release();
    finally
      FChatAgent := nil;
    end;
  except
  end;

  if Assigned(FInterpretator) then
  try
    try
      IInterface(FInterpretator)._Release();
    finally
      FInterpretator := nil;
    end;
  except
  end;

  if Assigned(FReasonAgent) then
  try
    try
      IInterface(FReasonAgent)._Release();
    finally
      FReasonAgent := nil;
    end;
  except
  end;

  if Assigned(FReasoner) then
  try
    try
      IInterface(FReasoner)._Release();
    finally
      FReasoner := nil;
    end;
  except
  end;

  Result := Res;
end;

class function TAssistantProgram.GetInstance(): TAssistantProgram;
begin
  Result := TAssistantProgram(inherited GetInstance());
end;

function TAssistantProgram.GetModuleByIndex(Index: Integer): TAssistantModule;
begin
  if (Index >= 0) and (Index < Length(FModules)) then
    Result := FModules[Index]
  else
    Result := nil;
end;

function TAssistantProgram.GetModuleByLocalID(LocalID: Integer): TAssistantModule;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(FModules) do
    if FModules[i].Handle = LocalID then
    begin
      Result := FModules[i];
      Exit;
    end;
end;

function TAssistantProgram.GetModuleCount(): Integer;
begin
  Result := Length(FModules);
end;

function TAssistantProgram.GetSendMessageEvent(): TProfMessageEvent;
begin
  Result := FSendMessageEvent;
end;

procedure TAssistantProgram.InitChatAgent();
begin
  FChatAgent := TAiChatAgent.Create();
  FChatAgent.Initialize();
  FChatAgent.OnSendMessageToCore := SendStrMessage;
  FChatAgent.OnAddToLog := AddToLog;
  FCore.Agents.Add(FChatAgent);
end;

function TAssistantProgram.Initialize(): TProfError;
begin
  Result := inherited Initialize();

  InitLog();

  // �������������� �������� ������
  //CreateKnowlegeBase();
  // ��������� ������� ����������� ������� � ��
  CheckKB();
  // ������� ������������� ����
  CreateInterpretator();

  // ������� ������� ����� ���������� ������
  CreateReasonAgent();

  // �������������� ������ ���-���
  InitChatAgent();

  AddToLog(lgNone, ltInformation, '-');

  //FCore.OnSendMessage := SendMessage;
  //FCore.OnSendMessageX := SendMessageX;
end;

procedure TAssistantProgram.InitLog();
var
  Log: TALogFileText;
begin
  if (FLogFileName = '') then
    FLogFileName := FExePath + AiLogDir + PathDelim + Self.ProgramName + '.' + FILE_EXT_LOG;
  Log := TALogFileText.Create();
  Log.FileName := FLogFileName;
  Log.Initialize();
  FLogDocuments.Add(Log.GetSelf());
end;

procedure TAssistantProgram.InitReasoner();
begin
  FReasoner := TAiReasonerModule.Create();
  FReasoner.Initialize();
  //FCore.AddModule(FReasoner);
end;

procedure TAssistantProgram.LoadModules();
var
  sr: TSearchRec;
  i: Integer;
  path: string;
  ModuleInfo: TModuleInfo;
begin
  try
    path := FExePath;
    i := FindFirst(path + FSystem.ModulesDir + '\*.dll', faAnyFile, sr);
    while (i = 0) do
    begin
      //LogRichEdit.Lines.Add('������ ���� ' + sr.Name);

      try
        if (TAssistantModule.CheckModule(path + FSystem.ModulesDir + '\' + sr.Name, ModuleInfo) = 0) then
        begin
          //LogRichEdit.Lines.Add('������ ������ ' + ModuleInfo.ModuleFullName);
          NewModule(path + FSystem.ModulesDir + '\' + sr.Name);
        end;
      except
        //LogRichEdit.Lines.Add('������ ��� �������� DLL ������ ' + sr.Name);
      end;

      i := FindNext(sr);
    end;
    SysUtils.FindClose(sr);

    // ������������� ���� �������
    for i := 0 to High(FModules) do
      FModules[i].InitializeModule(FModules[i].Handle, SystemProc);

    // ������ ���� �������
    for i := 0 to High(FModules) do
      FModules[i].RunModule();
  except
    //LogRichEdit.Lines.Add('������ ��� �������� DLL �������');
  end;
end;

function TAssistantProgram.NewModule(FileName: WideString): TAssistantModule;
begin
  Result := TAssistantModule.Create(FileName);
  AddModule(Result);
end;

function TAssistantProgram.RunFile(FileName: WideString): Boolean;
begin
  Result := False;
end;

function TAssistantProgram.RunScript(Code: WideString): Boolean;
var
  Tokenizer: TTokenizer;
  Token: WideChar;
  FPath: WideString;
  FMethodName: WideString;
  FParam: WideString;
begin
  Result := False;

  Tokenizer := TTokenizer.Create();
  Tokenizer.InputString := Code;
  //Tokenizer.Parse(Code);

  //FType := 0;
  FPath := '';
  FMethodName := '';
  FParam := '';
  while not(Tokenizer.Eof()) do
  begin
    Token := Tokenizer.NextChar();
    case Tokenizer.TokenType of
      CLASS_NAME_TOKEN_TYPE: // �����
        begin
          if Token = POINT_TOKEN then
          begin
            Tokenizer.AheadTokenType(METHOD_NAME_TOKEN_TYPE);
          end
          else
            FPath := FPath + Token;
        end;
      METHOD_NAME_TOKEN_TYPE: // �����
        begin
          if Token = '(' then
          begin
            Tokenizer.AheadTokenType(PARAM_TOKEN_TYPE);
          end
          else
            FMethodName := FMethodName + Token;
        end;
      PARAM_TOKEN_TYPE: // ������� ���������� ������
        begin
          if Token = '"' then
          begin
            Tokenizer.AheadTokenType(STRING_PARAM_TOKEN_TYPE);
          end
          else if Token = ')' then
          begin
            if (Tokenizer.NextChar() = ';') then
              Result := RunSystemMethod(FPath, FMethodName, FParam);
            //Tokenizer.BackTokenType();
          end;     
        end;
      STRING_PARAM_TOKEN_TYPE:
        begin
          if Token = '"' then
          begin
            Tokenizer.BackTokenType();
          end
          else
            FParam := FParam + Token;
        end;
    end;
  end;

  Tokenizer.Free();
end;

function TAssistantProgram.RunSystemMethod(ClassName, MethodName, Param: WideString): Boolean;
begin
  Result := False;

  if (ClassName = 'LogJournal') then
  begin
    if (MethodName = 'AddToLog') then
    begin
      if Assigned(LogJournal) then
        LogJournal.AddToLog(Param);
      Result := True;
    end;
  end;
end;

function TAssistantProgram.SendMessage(const Msg: WideString): Integer;
begin
  Result := inherited SendMessage(Msg);
  FSendMessageEvent.Run(Msg);
end;

function TAssistantProgram.SendMessageA(Msg: AMessage): Integer;
begin
  Result := 0;
  if Assigned(FOnMessageA) then
  try
    Result := FOnMessageA(Msg);
  except
  end;
end;

function TAssistantProgram.SendStrMessage(const Msg: WideString): Integer;
begin
  Result := FSendMessageEvent.Run(Msg);
end;

end.
