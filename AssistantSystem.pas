{**
@Abstract Assistant system
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 05.05.2012
}
unit AssistantSystem;

interface

type
  TAssistantSystem = class
  public
    // ������ ���������
    BootModuleFileName: WideString;
    {**
      ���������� ������������
      � ���� ���������� �������� ��������� ���� �������, ���������� � ���
      ����� ������ ��������� � �.�.
    }
    ConfigurationDir: WideString;
    ModulesDir: WideString;
  end;

implementation

end.
