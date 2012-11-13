{**
@Abstract Assistant app
@Author Prof1983 <prof1983@ya.ru>
@Created 05.04.2007
@LastMod 13.11.2012
}
unit AssistantApp;

{define ArAssistant}

interface

uses
  {$ifdef ArAssistant}ActiveX,{$endif}
  Forms,
  ABase, AOpenGlForm,
  {$ifdef ArAssistant}ArBuilderForm, ArTasksForm,{$endif}
  {$ifdef ArAssistant}ArKernelObj,{$endif}
  AssistantProgram, AssistantConsolePage,
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
  StartForm: TStartForm;
  //** ������� ���� ���������. ��� ���� �������� ����������� ��� �������� ��������� ����.
  AssistantForm: TAssistantForm;
  //FAssistantForm: TAssistantForm; - ArAssistant
  {** ���� ��������� ������������ ����������� }
  FFaceForm: TfmOpenGL;
  {$ifdef ArAssistant}
  {** Kernel }
  Kernel: TArKernel;
  //** ���� ������������ ������ ���� ������
  FKnowlegeBasePath: WideString;
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
  if Assigned(AssistantProgram) then
  try
    try
      AssistantProgram.Stop();
      AssistantProgram.Finalize();
      AssistantProgram.Free();
    finally
      AssistantProgram := nil;
    end;
  except
  end;

  {$ifdef ArAssistant}
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

  {ifdef ArAssistant}
  // �������������� � ��������� ���������
  //AssistantProgram.SendMessageEvent.Connect(FAssistantForm.AddMessage);
  //AssistantProgram.OnAddToLog := FAssistantForm.AddToLog;
  {endif}

  AssistantProgram_Initialize();
  Application.ProcessMessages();

  Application.CreateForm(TfmOpenGL, FFaceForm);
  // ������� ������� ���� ���������
  AssistantForm := TAssistantForm.Create(FFaceForm);
  AssistantConsolePage_Init(AssistantForm);

  try
    FFaceForm.IsStar := True;
    FFaceForm.Top := 600;
    FFaceForm.Left := 0;
    FFaceForm.Height := 200;
    FFaceForm.Width := 200;
    FFaceForm.Initialize();
    FFaceForm.Show();
  except
  end;

  try
    AssistantForm.Top := 0;
    AssistantForm.Left := 0;
    AssistantForm.Height := 600;
    AssistantForm.Width := 800;
    //AssistantForm.OnMessage := AssistantProgram.OnSendMessage;
    //AssistantForm.OnExit := DoExit;
    // �������� �� ���������, � �� ����������� � ����.
    AssistantForm.IsClose := True;
    AssistantForm.Init();
    AssistantForm.Core := AssistantProgram_GetCore();
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
  AssistantProgram.Start();
  Application.Run();
end;

end.
