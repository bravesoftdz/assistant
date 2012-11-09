{**
@Abstract Assistant app
@Author Prof1983 <prof1983@ya.ru>
@Created 17.08.2012
@LastMod 17.08.2012
}
unit AssistantApp;

interface

uses
  Forms,
  AssistantProgram, fAssistant, fStart;

procedure AssistantApp_Fin();
procedure AssistantApp_Init();
procedure AssistantApp_Run();

implementation

var
  {**
  ����� ���������� ������� �����.
  ������� �� �������, ����������� � ������� ���� �������� �������� ��� ����,
  ����� AssistantForm ����� ���� ������������ �� ������ � ����, �� � � ������ ��������.
  }
  //AssistantFormControl: TAssistantFormControl;
  //** ������� ������ ���������
  AssistantProgram: TAssistantProgram;
  StartForm: TStartForm;
  //** ������� ���� ���������. ��� ���� �������� ����������� ��� �������� ��������� ����.
  AssistantForm: TAssistantForm;
  //TrayIcon: TAUITrayIcon;

procedure AssistantApp_Fin();
begin
end;

procedure AssistantApp_Init();
begin
  Application.Initialize;
  Application.Title := 'Assistant';

  // ��������� �����
  Application.CreateForm(TStartForm, StartForm);
  Application.ProcessMessages();
  // ������� ������� ������ ���������
  AssistantProgram := TAssistantProgram.Create();
  Application.ProcessMessages();
  AssistantProgram.Initialize();
  Application.ProcessMessages();

  // ������� ������� ���� ���������
  Application.CreateForm(TAssistantForm, AssistantForm);
  // �������� �� ���������, � �� ����������� � ����.
  AssistantForm.IsClose := True;
  AssistantForm.Init();
  AssistantForm.Core := AssistantProgram.Core;
  AssistantForm.Initialize();

  // --- TrayIcon ---
  {
  TrayIcon := TAUITrayIcon.Create();
  TrayIcon.IsActive := True;
  //TrayIcon.Icon := Application.Icon;
  }

  // ������� ������ ���������� ������ �����
  //AssistantFormControl := TAssistantFormControl.Create();
  //AssistantFormControl.AssistantForm := AssistantForm;
end;

procedure AssistantApp_Run();
begin
  Application.Run();
end;

end.
