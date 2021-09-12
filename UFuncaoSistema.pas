unit UFuncaoSistema;

interface
uses
  StrUtils,
  Vcl.forms,
  SysUtils,
  classes,
  //StdCtrls,
  Windows,
  Registry,
  rtti,
  IniFiles,
  MaskUtils;

type
  TFuncaoSistema = class
  public
    function  ColocaTextoDireita(Texto: string; Qtd: integer; Ch: Char): string;
    function  ColocaTextoEsquerda(Texto: string; Qtd: integer; Ch: Char): string;
    function  centraliza(texto: String; tamanho: Integer): String;
    Function FormataFone(Fone: String): string;
    procedure GravarLog(msg: string);
    Function  SerialNum(FDrive:String) :String;
    function mascaratel(valor: string):string;
    function NomeComputardor():string;
    function NomeUsuario():string;
    function GetFileVersion(Prog: string): string;
    function SerializarINI(Arquivo, chave: string; obj: TObject): TObject;
    function GravarINI(Arquivo, chave: string; obj: TObject): TObject;
    function Rodape(): integer;
    procedure MostrarMsgUsuario(msg: string);
  end;

implementation

{ TFuncaoSistema }

function TFuncaoSistema.centraliza(texto: String; tamanho: Integer): String;
var aux: Integer;
    textoCentralizado: String;
begin
   if (tamanho > length(texto)) then
   begin
      aux := trunc((tamanho - length(texto))/ 2);
      textoCentralizado := stringOfchar(' ',aux) + texto + stringOfchar(' ',aux);
      if (Length(textoCentralizado) < tamanho) then
         textoCentralizado := textoCentralizado+' ';
    end
    else
      textoCentralizado := texto;

  Result := textoCentralizado;
end;

function TFuncaoSistema.ColocaTextoDireita(Texto: string; Qtd: integer;
  Ch: Char): string;
var
  x: integer;
  str: string;
begin
   if  Ch = '' then
      Ch:= Chr( 32 ); { Espaço }

   if  Length(Texto) > Qtd then
      Result := Copy( Texto, (Length(Texto)-Qtd) + 1, Length(Texto) )
   else
   begin
      str := '';
      for x := Length(Texto) to Qtd - 1 do
      begin
         str := str + Ch;
      end;
      Result := str + Texto;
   end

end;

function TFuncaoSistema.ColocaTextoEsquerda(Texto: string; Qtd: integer;
  Ch: Char): string;
  var
 x: integer;
begin
   if  Ch = '' then
      Ch := Chr( 32 ) { Espaço }
  {endif};

   if  Length(Texto) > Qtd then
      Result := Copy( Texto, 0, Qtd )
   else
   begin
      x := Length( Texto );
      for  Qtd := x to Qtd-1 do
      begin
         Texto := Texto + Ch;
      end;
      Result := Texto;
   end

end;

function TFuncaoSistema.FormataFone(Fone: String): string;
VAR I : Integer;
    ddd, prefix, tel : String;
begin
  ddd := '';
  prefix := '';
  tel := '';

  //pega o ddd formatado
  ddd := '(';
  for i := 1 to 2 do
    begin
      ddd := ddd+fone[i];
      //Inc(i);
    end;
  ddd := ddd + ')';

  //prefixo de 3 dígitos
  if Length(Fone) = 10 then
    begin
      for i := 3 to length(Fone)-4 do
        begin
          prefix := prefix + Fone[i]
          //Inc(i);
        end;
      prefix := prefix + '-';
    end;

  //prefixo de 4 digitos
  if Length(Fone) = 9 then
    begin
      for i := 3 to length(Fone)-4 do
        begin
          prefix := prefix + Fone[i]
          //Inc(i);
        end;
      prefix := prefix + '-';
    end;

  //telefone
  for i := length(Fone)-3 to length(Fone) do
    tel := tel + Fone[i];

  //junta tudo
  Result := ddd + prefix + tel;

end;

function TFuncaoSistema.GetFileVersion(Prog: string): string;
var
 VerInfoSize: DWORD;
 VerInfo: Pointer;
 VerValueSize: DWORD;
 VerValue: PVSFixedFileInfo;
 Dummy: DWORD;
 V1, V2, V3, V4: Word;
begin
 try
   VerInfoSize := GetFileVersionInfoSize(PChar(Prog), Dummy);
   GetMem(VerInfo, VerInfoSize);
   GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
   VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
   with (VerValue^) do
   begin
     V1 := dwFileVersionMS shr 16;
     V2 := dwFileVersionMS and $FFFF;
     V3 := dwFileVersionLS shr 16;
     V4 := dwFileVersionLS and $FFFF;
   end;
   FreeMem(VerInfo, VerInfoSize);
   Result := Format('%d.%d.%d.%d', [v1, v2, v3, v4]);
 except
   Result := '1.0.0';
 end;
end;

function TFuncaoSistema.GravarINI(Arquivo, chave: string; obj: TObject): TObject;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
   Propriedades: TRttiProperty;
   Fini : TIniFile;
begin
  Fini := TIniFile.Create(Arquivo);
  Tipo := Contexto.GetType(obj.ClassInfo);

  for Propriedades in Tipo.GetProperties do
  begin
    case Propriedades.PropertyType.TypeKind of
      tkInteger:
        Fini.WriteInteger(chave, Propriedades.Name, Propriedades.GetValue(obj).AsInteger);
      tkUString, tkLString, tkString, tkWString:
        Fini.WriteString(chave, Propriedades.Name, Propriedades.GetValue(obj).AsString);
      tkEnumeration:
        Fini.WriteBool(chave, Propriedades.Name, Propriedades.GetValue(obj).AsBoolean);
      tkFloat:
        Fini.WriteFloat(chave, Propriedades.Name, Propriedades.GetValue(obj).AsExtended);
    end;
  end;
  Result := obj;

end;

procedure TFuncaoSistema.GravarLog(msg: string);
var
  arq: TextFile;
  s, nome: string;
begin
   s := GetCurrentDir  +'\LOGS\';
   if not DirectoryExists(s) then
      ForceDirectories(s);
  nome := FormatDateTime('yyyy-mm-dd', now);
  try
    s := s  +'\'+ nome+ '.LOG';
    AssignFile(arq, s);
    if FileExists(s) then
    begin
      Append(arq);
    end
    else
    begin
      Rewrite(arq);
    end;
    Writeln(arq, FormatDateTime('yyyy-dd-mm hh:mm:ss', now) + ' - ' + msg);
    CloseFile(arq);
  finally

  end;

end;

function TFuncaoSistema.mascaratel(valor: string): string;
var Mascara:string;
begin
   valor:= StringReplace(valor,'(','',[rfReplaceAll]);
   valor:= StringReplace(valor,')','',[rfReplaceAll]);
   valor:= StringReplace(valor,'-','',[rfReplaceAll]);
   valor:= trim(valor);
   case Length(trim(valor)) of
      10 : Mascara := '\(00\)0000-00009;0;_';
      11 : Mascara := '\(00\)00000-0000;0;_';
      else Mascara := '\(00\)000000009;0;_';
   end;
   Result:=  trim(FormatMaskText(Mascara, valor));
end;

procedure TFuncaoSistema.MostrarMsgUsuario(msg: string);
begin
  Application.MessageBox(PWideChar(msg),'Atenção');
end;

function TFuncaoSistema.NomeComputardor: string;
var
   Computer: string;
   CSize: DWORD;
begin
  CSize:= 255;
  SetLength(Computer, CSize);
  Windows.GetComputerName(PChar(Computer),CSize );
  Computer:= string(PChar(Computer));
  Result  :=  UpperCase(Computer);
end;

function TFuncaoSistema.NomeUsuario: string;
var
  I: DWord;
  user: string;
begin
  I := 255;
  SetLength(user, I);
  Windows.GetUserName(PChar(user), I);
  user   := string(PChar(user));
  result := UpperCase(user);
end;

function TFuncaoSistema.Rodape: integer;
var
  rRect: TRect;
  rBarraTarefas: HWND;
begin
  // Localiza o Handle da barra de tarefas
  rBarraTarefas := FindWindow('Shell_TrayWnd', nil);

  // Pega o "retângulo" que envolve a barra e sua altura
  GetWindowRect(rBarraTarefas, rRect);

  // Retorna a altura da barra
  Result := rRect.Bottom - rRect.Top;

end;

function TFuncaoSistema.SerializarINI(Arquivo, chave: string; obj: TObject): TObject;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Fini:TIniFile;
begin
  Result := obj;
  if not(FileExists(Arquivo)) then
    exit;
  Fini := TIniFile.Create(Arquivo);
  Tipo := Contexto.GetType(obj.ClassInfo);
  for Propriedade in Tipo.GetProperties do
  begin
    case Propriedade.PropertyType.TypeKind of
      tkInteger:
        Propriedade.SetValue(obj, Fini.ReadInteger(chave, Propriedade.Name, 0));
      tkUString, tkLString, tkString, tkWString:
        Propriedade.SetValue(obj, Fini.ReadString(chave, Propriedade.Name, ''));
      tkEnumeration:
        Propriedade.SetValue(obj, Fini.ReadBool(chave, Propriedade.Name, False)
          );
      tkFloat:
        Propriedade.SetValue(obj, Fini.ReadFloat(chave, Propriedade.Name, 0));
    end;
  end;

end;

function TFuncaoSistema.SerialNum(FDrive: String): String;
var
Serial: DWord;
DirLen, Flags: DWord;
DLabel : Array[0..11] of Char;
begin
   Try
      GetVolumeInformation(PChar(FDrive+':\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
      Result := IntToHex(Serial,8);
   Except
      Result := '';
   end;
end;

end.
