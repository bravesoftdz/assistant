{**
@Abstract Assistant app
@Author Prof1983 <prof1983@ya.ru>
@Created 17.08.2012 (05.04.2007)
@LastMod 09.11.2012
}
unit AssistantApp;

{define ArAssistant}

interface

uses
  {$ifdef ArAsssistant}ActiveX,{$endif}
  Forms,
  {$ifdef ArAssistant}ABase, AOpenGlForm,{$endif}
  {$ifdef ArAssistant}ArBuilderForm, ArKernelObj, ArTasksForm,{$endif}
  {$ifdef ArAssistant}ArAssistantProgram,{$endif}
  AssistantProgram,
  {$ifdef ArAssistant}ArAssistantForm,{$endif}
  fAssistant,
  fStart;

procedure AssistantApp_Fin();
procedure AssistantApp_Init();
procedure AssistantApp_Run();

implementation

var
  //** ������� ������ ���������
  AssistantProgram: TAssistantProgram;
  //prAssistant: TArAssistantProgram; - ArAsssitant
  StartForm: TStartForm;
  //** ������� ���� ���������. ��� ���� �������� ����������� ��� �������� ��������� ����.
  AssistantForm: TAssistantForm;
  //FAssistantForm: TAssistantForm; - ArAssistant
  {$ifdef ArAssistant}
  {** ���� ��������� ������������ ����������� }
  FFaceForm: TfmOpenGL;
  {** Kernel }
  Kernel: TArKernel;
  {$endif}
  //TrayIcon: TAUITrayIcon;

// --- Events ---

{$ifdef ArAssistant}
function DoExit(): AInt; stdcall;
begin
  if Assigned(FFaceForm) then
  try
    FFaceForm.Close();
  except
  end;
  Result := 0;
end;
{$endif}

procedure AssistantApp_Fin();
begin
  {$ifdef ArAssistant}
  if Assigned(AssistantProgram) then
  try
    try
      AssistantProgram.Disconnect();
      AssistantProgram.Stop();
      AssistantProgram.Finalize();
      AssistantProgram.Free();
    finally
      AssistantProgram := nil;
    end;
  except
  end;

  if Assigned(Kernel) then
  try
    try
      Kernel.Free();
    finally
      Kernel := nil;
    end;
  except
  end;
  {$endif}
end;

procedure AssistantApp_Init();
begin
  Application.Initialize;
  Application.Title := 'Assistant';

  // --- Boot ---
  {$ifdef ArAssistant}
  // ������� � �������������� ���� ��������� (Kernel)
  Kernel := TArKernel.Create();
  Kernel.Initialize();
  {$endif}

  // --- Init ---

  {$ifdef ArAssistant}
  CoInitialize(nil);
  {$endif}

  // ��������� �����
  Application.CreateForm(TStartForm, StartForm);
  Application.ProcessMessages();

  // ������� ������� ������ ���������
  AssistantProgram := TAssistantProgram.Create();
  Application.ProcessMessages();

  {$ifdef ArAssistant}
  // �������������� � ��������� ���������
  //prAssistant.SendMessageEvent.Connect(FFaceForm.AddMessage);
  AssistantProgram.SendMessageEvent.Connect(FAssistantForm.AddMessage);
  //prAssistant.SendMessageEventX.Connect(FFaceForm.AddMessageX);
  //prAssistant.SendMessageEventX.Connect(FAssistantForm.AddMessageX);
  AssistantProgram.OnAddToLog := FAssistantForm.AddToLog;
  {$endif}

  AssistantProgram_Initialize();
  Application.ProcessMessages();

  {$ifdef ArAsssitant}
  Application.CreateForm(TfmOpenGL, FFaceForm);
  FAssistantForm := TAssistantForm.Create(FFaceForm);
  {$else}
  // ������� ������� ���� ���������
  Application.CreateForm(TAssistantForm, AssistantForm);
  {$endif}

  {$ifdef ArAssistant}
  try
    //FFaceForm.OnAddToLog := prAssistant.AddToLog;
    //FFaceForm.OnSendMessage := prAssistant.AddMessage;
    //FFaceForm.OnSendMessageX := prAssistant.AddMessageX;
    FFaceForm.IsStar := True;
    FFaceForm.Top := 600;
    FFaceForm.Left := 0;
    FFaceForm.Height := 200;
    FFaceForm.Width := 200;
    FFaceForm.Initialize();
  except
  end;
  {$endif}

  try
    AssistantForm.Top := 0;
    AssistantForm.Left := 0;
    AssistantForm.Height := 600;
    AssistantForm.Width := 800;
    {$ifdef ArAssistant}
    AssistantForm.OnMessage := AssistantProgram.OnSendMessage;
    //FAssistantForm.OnSendMessageX := prAssistant.AddMessageX;
    AssistantForm.OnExit := DoExit;
    {$else}
    // �������� �� ���������, � �� ����������� � ����.
    AssistantForm.IsClose := True;
    AssistantForm.Init();
    AssistantForm.Core := AssistantProgram_GetCore();
    {$endif}
    AssistantForm.Initialize();
    AssistantForm.Show();
  except
  end;

  // --- TrayIcon ---
  {
  TrayIcon := TAUITrayIcon.Create();
  TrayIcon.IsActive := True;
  //TrayIcon.Icon := Application.Icon;
  }
end;

procedure AssistantApp_Run();
begin
  {$ifdef ArAssistant}
  AssistantProgram.Start();
  {$endif}

  Application.Run();
end;

end.
