{**
@Abstract Assistant action tree
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012
}
unit AssistantActionTree;

interface

uses
  AilCode;

type //** ��������
  TAction = class
  private
      //** ����������� ���
    FCode: TAilCode;
  public
      //** ����������� ���
    property Code: TAilCode read FCode write FCode;
  end;

type //** ���� ��������
  TActionNode = class
  private
    // ������ ��������� ���������� ������� ����������, ���� ��������� ��� ��������
    //FChanges:
    // ��������� �������� ���������� ��������
    //FChildActions:
    // ����������� ������� ��� ���������� ����� ��������
    //FConditions:
    // ������ ��������� (�������� ����� ����������)
    // ...
    // ���� ��������
    //FAction
  end;

type //** ������ ������������������ �������� (������ �������)
  TActionTree = class
  private
    FRoot: TActionNode;
  public
    property Root: TActionNode read FRoot;
  end;

implementation

end.
