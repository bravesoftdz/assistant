{**
@Abstract Agent Virtual Mashine / Assistant Virtual Mashine (AVM)
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012

Agent Virtual Mashine / Assistant Virtual Mashine (AVM)
����������� ������
}
unit AssistantVirtualMachine;

interface

uses
  AssistantEnviromentObj, AssistantRunner;

type //** ����������� ������ ����������� ������ ������������
  TAssistantVirtualMachine = class
  private
      //** ���������� ����� ��� �������
    FEnviroment: TAssistantEnviroment;
    {**
      ����������� ����. ��������� ���� ����������� ��� ������� �����������
      (� ����� ������ ���������� ��� ������� ���� ����������)
    }
    FRunners: array of TRunner;
  public
    function AddRunner(Runner: TRunner): Integer;
    procedure Start();
  public
      //** ���������� ����� ��� �������
    property Enviroment: TAssistantEnviroment read FEnviroment write FEnviroment;
  end;

implementation

{ TAssistantVirtualMachine }

function TAssistantVirtualMachine.AddRunner(Runner: TRunner): Integer;
begin
  Result := Length(FRunners);
  SetLength(FRunners, Result + 1);
  FRunners[Result] := Runner;
end;

procedure TAssistantVirtualMachine.Start();
var
  i: Integer;
begin
  // ��������������� ��������� ���� ���������
  for i := 0 to High(FRunners) do
    FRunners[i].Resume();
end;

end.
