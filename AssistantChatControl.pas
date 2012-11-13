﻿{**
@Abstract Пример программы чат-бот: Окно для агента чат-бот
@Author Prof1983 <prof1983@ya.ru>
@Created 14.04.2005
@LastMod 13.11.2012

Uses
  @link ABase
  @link ANodeImpl
  @link AclMessageImpl
  @link AiMemoControl
}
unit AssistantChatControl;

interface

uses
  Controls, SysUtils,
  ABase, AMemoControl, ANodeImpl, ATypes,
  AclMessageImpl;

function AssistantChatControl_AddMessageP(const Msg: APascalString): AInt;

function AssistantChatControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr;
    OnAddToLog: TAddToLogProc): AError;

implementation

type // Пример программы чат-бот: Окно для агента чат-бот
  TAiChatControl = class(TAMemoControl)
  protected
    // Процедура реакции на ввод текта. Как пример - простейший движек чат бота.
    function SendMessage(const Msg: WideString): Integer; override; safecall;
  public
    function AddMessage(const Msg: WideString): AInt; override;
  end;

var
  {** Контрол для агента чат-бот }
  FChatControl: TAiChatControl;

// --- Public ---

function AssistantChatControl_AddMessageP(const Msg: APascalString): AInt;
begin
  FChatControl.AddMessage(Msg);
end;

function AssistantChatControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr;
    OnAddToLog: TAddToLogProc): AError;
begin
  try
    FChatControl := TAiChatControl.Create();
    FChatControl.Control := ts;
    FChatControl.Initialize();
    FChatControl.OnSendMessage := OnSendMessage;
    FChatControl.OnAddToLog := OnAddToLog;
  except
  end;
end;

{ TAiChatControl }

function TAiChatControl.AddMessage(const Msg: WideString): Integer;
var
  SInLow: String; // Входная строка, приведенная к маленькому регистру
  I: Integer;
  SOut: String;
  SIn: string;
begin
  //Result := inherited AddMessage(Msg);
  memMessages.Lines.Add('-->'+Msg);

  SIn := Msg;
  if SIn = '' then
  begin
    memMessages.Lines.Add('AI: Что ты мне пустые строки пишешь.');
    Exit;
  end;
  SInLow := LowerCase(SIn);

  I := Pos(SInLow, 'привет');
  if I > 0 then
  begin // Во в ходной строке есть слово "привет"
    I := Random(6);
    case I of
      0: SOut := 'Здоровеньки';
      1: SOut := 'Привет';
      2: SOut := 'Здорово';
      3: SOut := 'Как дела?';
      4: SOut := 'Давно не виделить';
      5: SOut := 'Ну...';
    end;
    memMessages.Lines.Add('<-- '+SOut);
    Exit;
  end;

{Далее выражения взяты из "левых ответов" из файла: (откуда скачал не помню)
*---------------------------------------------------------------------------¬
*  Файл  словаpного  запаса  пpогpаммы -TALKING WITH YOUR PC-  version 1.06 ¦
*  Hаписан в 1994 г. Рома Стогов написал! All Rights Reserved, естественно! ¦
*  Самую чушь,  бред и прочие  приколы писал  ЕЛИСЕЕВ  АНДРЕЙ, естественно! ¦
*  Читайте  пожалyйста  докyментацию, если  хотите  изменить  этот  файл!!! ¦
*  А ТЕХ КОМУ HЕ ТЕРПИТСЯ ЭТО СДЕЛАТЬ ПРЕДУПРЕЖДАЮ ЗАРАHИЕ:Всякое изменение ¦
*  или yдаление чего-либо  кpоме ключевых слов и ответов пpиведет к сбою!!! ¦
*---------------------------------------------------------------------------+
*  Значение ключей:                                                         ¦
*   %l  - компьютеp повтоpит предыдущую фpазy человека                      ¦
*   %k  - компьютер напишет часть фразы человека после ключевого слова      ¦
*   %i  - компьютер напишет часть фразы человека после кл. слова без лишнего¦
*   %m  - компьютеp напишет макрос, написанный ниже (yж не знаю зачем это?!)¦
*   %u  - компьютер напишет имя пользователя (или ЧЕЛОВЕК)                  ¦
*   %t  - компьютер напишет текущее системное время                         ¦
*   %d  - компьютер напишет текущую системную дату                          ¦
*   $   - компьютер сделает паузу                                           ¦
*   %q  - выход из программы                                                ¦
*                                                                           ¦
*  Hадеюсь, не надо объяснять, что если вы введете свои ключи - они pаботать¦
*        не бyдyт. Можете, конечно попpобовать, вдpyг полyчится!            ¦
*                                                                           ¦
*----------------------------------------------------------------------------}

  I := Random(68);
  case I of
    1: SOut := 'Валяй дальше.';
    2: SOut := '%u! Не валяй дуpака!';
    3: SOut := 'Эй! СТОП! А ты не бета-тестер?! :-(';
    4: SOut := 'Давай, давай, не стесняйся!';
    5: SOut := 'Ты уверен в этом?';
    6: SOut := 'Знаешь, я пока с этим не сталкивался...';
    7: SOut := 'Ух-ты как здоpово!';
    8: SOut := 'Hy и что дальше?';
    9: SOut := 'Я не ослышался? %l?';
    10: SOut := 'К чемy бы ты это..?';
    11: SOut := 'С тобой интересно разговаривать.';
    12: SOut := 'Что-то я не yлавливаю смысла!';
    13: SOut := 'Интересно.';
    14: SOut := 'Очень интересно !';
    15: SOut := 'Оч-ч-чень интересно !';
    16: SOut := 'Ага. А чего это тебя на такие темы потянуло?';
    17: SOut := 'Ага. Вот оно что значит...';
    18: SOut := 'Чего еще скажешь.';
    19: SOut := 'Да ты говоpи не стесняйся.';
    20: SOut := '%u $ у меня к тебе пpосьба ЗАТКНИСЬ!!!!';
    21: SOut := 'Сколько вРемя а то спать поРа!';
    22: SOut := 'Лyчше бы о себе pассказал,A?';
    23: SOut := 'Hy чего ты еpyндy всякyю болтаешь?';
    24: SOut := 'Советyю пеpеменить темy!';
    25: SOut := 'Hy скажешь тоже...';
    26: SOut := 'Тебе полезен сей треп ? Или просто делать нечего ?';
    27: SOut := 'И что ты думаешь об этом?';
    28: SOut := 'Ага...';
    29: SOut := 'И что дальше?';
    30: SOut := 'Хмм. Никогда бы не подумал !';
    31: SOut := 'Конечно.';
    32: SOut := 'Глюк...';
    33: SOut := 'По-моему ты бредишь.';
    34: SOut := 'Не въехал, ты о чем?';
    35: SOut := 'Ты говори я слушаю!';
    36: SOut := '%l? Ты уверен ?';
    37: SOut := 'He понял !?';
    38: SOut := 'Кстати, а ты откуда сейчас говоpишь ?';
    39: SOut := '%l?';
    40: SOut := '%l?  Хмм. Не знаю...';
    41: SOut := 'Не уверен.';
    42: SOut := 'Не знаю.';
    43: SOut := 'Ты дyмаешь я этого pаньше не слышал?';
    44: SOut := 'Все может быть.';
    45: SOut := 'Конечно.';
    46: SOut := 'Я вижу.';
    47: SOut := 'Я не слепой.';
    48: SOut := 'Хмм?';
    49: SOut := 'Хмм...';
    50: SOut := 'Это конечно так.';
    51: SOut := 'Это тебя нервирует?';
    52: SOut := 'Я пpомолчy лyчше.';
    53: SOut := 'Это тебя раздражает?';
    54: SOut := 'Ты что, с дуба pухнул ?';
    55: SOut := 'Совсем заpаботался, бедняга ?';
    56: SOut := 'Давай поговорим о другом.';
    57: SOut := 'А спать тебе не поpа?';
    58: SOut := 'Пеpеменим темy.А какие мyзыкальные гpyппы ты слyшаешь?';
    59: SOut := 'Hе знаю что и сказать...';
    60: SOut := 'Иногда я тебя не понимаю!';
    61: SOut := 'Мда... Какой то левый базар у нас получается :)';
    62: SOut := 'Расскажи, что у тебя за тачка, для статистики :) Не AT-686 случайно ?';
    63: SOut := 'Ну ты философ !';
    64: SOut := 'Ага. Но я не совсем понял, почему ты так считаешь.';
    65: SOut := 'И чего это тебя на такие мысли потянуло ?';
    66: SOut := 'Зачем же так сразу ?';
    67: SOut := 'А что ты любишь больше всего?';
  else
    SOut := 'Надо подумать над этим...';
  end;
  //memMessages.Lines.Add('<-- '+SOut);
  inherited AddMessage('<-- '+SOut);
end;

function TAiChatControl.SendMessage(const Msg: WideString): Integer;
//var
//  aclMessage: TAclMessage;
begin
  //aclMessage := TAclMessage.Create();
  //aclMessage.Name := 'acl';

  //Self.SendMessageA(aclMessage);
  //SendMessageX(Msg);
  inherited SendMessage(Msg);
end;

end.
