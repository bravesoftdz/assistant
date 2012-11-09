{**
@Abstract Assistant engine
@Author Prof1983 <prof1983@ya.ru>
@Created 15.08.2007
@LastMod 16.03.2012
}
unit AssistantEngine;

interface

uses
  AssistantEnviromentObj, AssistantVirtualMachine;

type
  TAssistantEngine = class
  private
      //** ����� �������� �������
    FEnviroment: TAssistantEnviroment;
      //** ����������� ������ ���������������� ����� ��� �������
    FVirtualMachine: TAssistantVirtualMachine;
  public
    procedure Initialize();
  public
      //** ����� �������� �������
    property Enviroment: TAssistantEnviroment read FEnviroment;
      //** ����������� ������ ���������������� ����� ��� �������
    property VirtualMachine: TAssistantVirtualMachine read FVirtualMachine;
  end;

implementation

{ TAssistantEngine }

procedure TAssistantEngine.Initialize();
begin
  //TStartForm.AddToLog('������������� ����������� ������ (VirtualMachine)');
  // ������� ����������� ������
  FVirtualMachine := TAssistantVirtualMachine.Create();

  //TStartForm.AddToLog('������������� ����������� ����� (Enviroment)');
  FEnviroment := TAssistantEnviroment.Create();
  FVirtualMachine.Enviroment := FEnviroment;
end;

end.
