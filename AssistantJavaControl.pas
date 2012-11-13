{**
@Abstract ������� ��� ������ ��������� Java ��������
@Author Prof1983 <prof1983@ya.ru>
@Created 07.04.2007
@LastMod 13.11.2012
}
unit AssistantJavaControl;

interface

uses
  ABase, AJavaControl, JavaRuntime;

function AssistantJavaControl_RunAction(): AError;

implementation

var
  {** ������� ���������� Java ��������� (�� ��������) }
  FJavaControl: TJavaControl;

// --- Public ---

function AssistantJavaControl_Init(): AError;
begin
  xxx
end;

function AssistantJavaControl_RunAction(): AError;
var
  Strings: TStringList;
  Runtime: TJavaRuntime;
begin
  // jtest1
{*******************************************************}
{                                                       }
{       JNI Wrapper for Delphi Demo                     }
{       Demonstrates about the Simplest                 }
{       possible use of the JNI Wrapper.                }
{                                                       }
{       The main in HelloWorld.java simply spits        }
{       back the strings it receives. This wrapper      }
{       allows you to use TStringList to pass the       }
{       arguments. CallMain is a convenience method.    }
{                                                       }
{       Copyright (c) 1998 Jonathan Revusky             }
{                                                       }
{       Java and Delphi Freelance programming           }
{             jon@revusky.com                      }
{                                                       }
{*******************************************************}

// example that shows to launch a class
// using the JavaRuntime unit.

{ $APPTYPE CONSOLE}

//uses
//  SysUtils, Classes, JavaRuntime;

  FJavaControl := TJavaControl.Create();
  FJavaControl.Control := AddMainTab(0, 'Java');
  FJavaControl.Initialize();
  FJavaControl.AddToLog(lgGeneral, ltInformation, '=== ������ ===');

  try
    Strings := TStringList.Create();
    Strings.Add('Hello, world.');
    Strings.Add('Salut, monde.');
    Strings.Add('Hola, mundo.');
    Runtime := TJavaRuntime.GetDefault();    // �������� ����� �� ���������
    FJavaControl.AddToLog(lgGeneral, ltInformation, 'ClassPath: ' + Runtime.Classpath);
    Runtime.Printf := FJavaControl.Printf;   // ��������� ��������� ��� ������ ���������
    Runtime.CallMain('HelloWorld', Strings); // ��������� HelloWorld.main(Strings)
    Runtime.Wait();                          // ���� ��������� ����������
    Strings.Free();
  except
//    on EJvmException do
//      ShowException(ExceptObject, ExceptAddr);
  end;

  FJavaControl.AddToLog(lgGeneral, ltInformation, '=== ����� ===');
end;

end.
