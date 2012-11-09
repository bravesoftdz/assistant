{**
@Abstract Assistant settings
@Author Prof1983 <prof1983@ya.ru>
@Created 29.06.2007
@LastMod 16.03.2012

��������� ��������� Assistant
}
unit AssistantSettings;

interface

uses
  AiBase;

type //** @abstract(��������� ��������� Asssitant)
  TAssistantSettings = class
  private
    //** ������������� ��� �������. ����������� � Pool.
    FTaskTypeID: TAId;
    //** ��������� ����
    FTitle: WideString;
  public // ������ "General"
    //** ������������� ��� �������. ����������� � Pool.
    property TaskTypeID: TAIID read FTaskTypeID write FTaskTypeID;
    //** ��������� ����
    property Title: WideString read FTitle write FTitle;
  end;

implementation

end.
