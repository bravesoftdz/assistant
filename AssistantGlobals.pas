{**
@Abstract Assistant global consts and types
@Author Prof1983 <prof1983@ya.ru>
@Created 04.08.2007
@LastMod 16.03.2012
}
unit AssistantGlobals;

interface

const
  AgentsDefaultDir        = 'agents';
  ComponentsDefaultDir    = 'components';
  ConfigurationDefaultDir = 'configuration';
  DataDefaultDir          = 'data';
  DocumentstionDefaultDir = 'doc';
  ModulesDefaultDir       = 'modules';
  PluginsDefaultDir       = 'plugins';
  TempDefaultDir          = 'temp';
  UsersDefaultDir         = 'users';

const //** ��� ������-���������� �� ���������
  BootModuleDefaultFileName = 'org.aiassistant.boot.dll';

const //** ��������� ������������� �������� ������ (assistant.exe)
  MainModuleLoacalID = 1;

type
  TSystemProc = function(Sender, Receiver, Cmd, Param1, Param2: Integer): Integer; stdcall;

// -----------------------------------------------------------------------------
// PlatformAPI
// �������� API ������ � ������� ��������� AIAssistant

{
��������� AIAssistant ������������ �� ���� ������� �������� ������ �����������
����� DLL �������� ���������.
��������� ����� ��������� ������:
  Sender: Int32   - ����������� ���������
  Reveiver: Int32 - ���������� ���������
  Cmd: Int32      - �������
  Param1: Int32   - �������� 1: Int32 (��� ��������� �� ������� ������)
  Param2: Int32   - �������� 2: Int32 (��� ��������� �� ������� ������)
}

// ������� assistant.exe (Receiver = MainModuleLoacalID = 1)

const
  GetModuleListCount = 3; // Param1 - ��������� �� ���������� Int32
  GetModuleList = 4; // Param1 - ��������� �� ������� ������ array[0..count-1]; Param2 - count
  GetModuleInfo = 5; // Param1 - LocalID ������, Param2 - PModuleInfo2
  AddModule = 6;
  RemoteModule = 7;

implementation

end.
