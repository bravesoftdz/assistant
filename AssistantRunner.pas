{**
@Abstract Assistant runner
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012
}
unit AssistantRunner;

interface

uses
  AssistantActionTree, AssistantEnviromentObj, AssistantReasoner, AssistantSheduler;

type //** ��������� �������� ������ �����������
  TRunner = class
  private
      //** ������ ������������������ �������� (������ �������)
    FActionTree: TActionTree;
    FEnviroment: TAssistantEnviroment;
      //** ������ ����������� ������
    FReasoner: TReasoner;
      //** ����������� �������� (��� ���������� ������ ��������)
    FSheduler: TSheduler;
    //FThread: TThread;
  public
      //** ������������ ��������� ��������� ������� ���� ����� ����������� ������� Suspend
    procedure Resume();
  public
      //** ������ ������������������ �������� (������ �������)
    property ActionTree: TActionTree read FActionTree write FActionTree;
    //property Code: TAilCode read FCode write FCode;
    property Enviroment: TAssistantEnviroment read FEnviroment write FEnviroment;
      //** ������ ����������� ������
    property Reasoner: TReasoner read FReasoner write FReasoner;
      //** ����������� �������� (��� ���������� ������ ��������)
    property Sheduler: TSheduler read FSheduler write FSheduler;
  end;

implementation

{ TRunner }

procedure TRunner.Resume();
begin
  // ...
end;

end.
