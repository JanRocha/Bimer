unit UTabela;

interface

uses
  SysUtils,
  Rtti,
  UConexao,
  UFuncao,
  Classes,
  Data.SqlExpr;

type
  TTabela = class(TPersistent)
  private
    FFuncao: TFuncao;
    FConn: TConexao;
    FClasse: TObject;
    FNomeTabela: string;
    FPrimaryKey: string;
  published
    property Classe: TObject read FClasse write FClasse;
    property NomeTabela: string read FNomeTabela write FNomeTabela;
    property PrimaryKey: string read FPrimaryKey write FPrimaryKey;
  public
    function SerializarObjeto(qry:TSQLQuery; obj: TObject):TObject;
    function GetNewID(generator:string):int64;
    function PrepararInsert(): string;
    function PrepararUpdate():string;
    function ExecutarSQL(sql: string):Boolean;
    function Open(sql: string): TSQLQuery;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TTabela }

constructor TTabela.Create;
begin
  FConn:= TConexao.Create;
  FFuncao:= TFuncao.Create;
end;

destructor TTabela.Destroy;
begin
  FConn.Free;
  FFuncao.Free;
  inherited;
end;

function TTabela.ExecutarSQL(sql: string): Boolean;
begin
  Result:= true;
  FConn.sql.SQL.Text:= sql;
  try
    FFuncao.GravarLog('SQL: '+ sql);
    FConn.sql.ExecSQL();
  except on E: Exception do
    begin
      FFuncao.GravarLog('TTabela.ExecutarSQL: ' + E.Message);
      FFuncao.GravarLog('TTabela.ExecutarSQL: ' + sql);
      Result:= false;
    end;
  end;
end;

function TTabela.GetNewID(generator: string): int64;
var oSQL:string;
begin
   oSQL:= 'SELECT GEN_ID('+generator+', 1) FROM RDB$DATABASE';
   FConn.sql.Close;
   FConn.sql.SQL.Clear;
   FConn.sql.SQL.Add(oSQL);
   FConn.sql.Open;
   Result:= FConn.sql.FieldByName('GEN_ID').AsInteger;
end;

function TTabela.Open(sql: string): TSQLQuery;
begin
  FFuncao.GravarLog('SQL: '+ sql);
  FConn.sql.SQL.Text:= sql;
  FConn.sql.Open();
  Result:= FConn.sql;
end;
    {$WARNINGS OFF}
function TTabela.PrepararInsert: string;
var
  Contexto: TRttiContext;
  Tipo    : TRttiType;
  Prop    : TRttiProperty;
begin
  Result:= 'INSERT INTO ' + NomeTabela + ' (';
  Tipo := Contexto.GetType(Classe.ClassInfo);
  for Prop in Tipo.GetProperties do
  begin
    Result:= Result + Prop.Name + ',';
  end;
  try
    Result:= Copy(Result,0,Length(Result)-1);
    Result:= Result + ') VALUES (';
    Tipo := Contexto.GetType(Classe.ClassInfo);

    for Prop in Tipo.GetProperties do
    begin
      case Prop.PropertyType.TypeKind of
        tkInteger,
        tkInt64,
        tkEnumeration:
        begin
          Result:= Result + IntToStr(Prop.GetValue(Classe).AsInt64) + ',';
        end;
        tkFloat:
        begin
          if Prop.PropertyType.Name = 'TDate' then
          begin
            if FormatDateTime('dd.mm.yyyy',Prop.GetValue(Classe).AsVariant) = '30.12.1899' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('dd.mm.yyyy', Prop.GetValue(Classe).AsVariant))  + ',';
          end
          else if(Prop.PropertyType.Name = 'TDateTime') then
          begin
            if FormatDateTime('dd.mm.yyyy hh:mm:ss',Prop.GetValue(Classe).AsVariant) = '30.12.1899 00:00:00' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('dd.mm.yyyy hh:mm:ss', Prop.GetValue(Classe).AsVariant)) + ',';
          end
          else if(Prop.PropertyType.Name = 'TTime') then
          begin
            if FormatDateTime('hh:mm:ss',Prop.GetValue(Classe).AsVariant) = '00:00:00' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('hh:mm:ss', Prop.GetValue(Classe).AsVariant)) + ',';
          end
          else
            Result:= Result +StringReplace(CurrToStr(Prop.GetValue(Classe).AsCurrency),',','.',[rfReplaceAll]) + ',';
        end
        else
        begin
          Result:= Result + QuotedStr(Prop.GetValue(Classe).AsString)  + ',';
        end;
      end;
    end;
    Result:= Copy(Result,0,Length(Result)-1);
    Result:=Result + ')';
  except on E: Exception do
    begin
      result:= e.Message + Prop.PropertyType.Name;
    end;
  end;
end;
 {$WARNINGS ON}
function TTabela.PrepararUpdate: string;
var
  Contexto: TRttiContext;
  Tipo    : TRttiType;
  Prop    : TRttiProperty;
  where   :string;
begin
  try
    Result:= 'UPDATE ' + NomeTabela + ' SET ';
    Tipo := Contexto.GetType(Classe.ClassInfo);
    for Prop in Tipo.GetProperties do
    begin
      if (UpperCase(Prop.Name) = 'ID') then
      begin
        where := ' WHERE ID = '+ IntToStr(Prop.GetValue(Classe).AsInt64);
        Continue;
      end
      else if (UpperCase(Prop.Name) = PrimaryKey) then
      begin
        where := ' WHERE '+ PrimaryKey+' = '+ IntToStr(Prop.GetValue(Classe).AsInt64);
        Continue;
      end;


      Result:= Result + Prop.Name  + '=';
      case Prop.PropertyType.TypeKind of
        tkInteger,
        tkInt64,
        tkEnumeration:
        begin
          Result:= Result + IntToStr(Prop.GetValue(Classe).AsInt64) + ',';
        end;
        tkFloat:
        begin
          if Prop.PropertyType.Name = 'TDate' then
          begin
            if FormatDateTime('dd.mm.yyyy',Prop.GetValue(Classe).AsVariant) = '30.12.1899' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('dd.mm.yyyy', Prop.GetValue(Classe).AsVariant)) + ',';
          end
          else if(Prop.PropertyType.Name = 'TDateTime') then
          begin
            if FormatDateTime('dd.mm.yyyy hh:mm:ss',Prop.GetValue(Classe).AsVariant) = '30.12.1899 00:00:00' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('dd.mm.yyyy hh:mm:ss', Prop.GetValue(Classe).AsVariant)) + ',';
          end
          else if(Prop.PropertyType.Name = 'TTime') then
          begin
            if FormatDateTime('hh:mm:ss',Prop.GetValue(Classe).AsVariant) = '00:00:00' then
            begin
              Result:= Result + 'null'+ ',';
            end
            else
              Result:= Result + QuotedStr(FormatDateTime('hh:mm:ss', Prop.GetValue(Classe).AsVariant)) + ',';
          end
          else
            Result:= Result +StringReplace(CurrToStr(Prop.GetValue(Classe).AsCurrency),',','.',[rfReplaceAll]) + ',';
        end
        else
        begin
          Result:= Result + QuotedStr(Prop.GetValue(Classe).AsString)  + ',';
        end;
      end;
    end;
    Result:= Copy(Result,0,Length(Result)-1);
    Result:= Result + where;
  except on E:Exception do
    begin

    end
  end;
end;

function TTabela.SerializarObjeto(qry: TSQLQuery; obj: TObject): TObject;
var
  Contexto: TRttiContext;
  Tipo    : TRttiType;
  Prop    : TRttiProperty;
begin
  Tipo := Contexto.GetType(obj.ClassInfo);
  for Prop in Tipo.GetProperties do
  begin
    case Prop.PropertyType.TypeKind of
      tkInteger,
      tkEnumeration:
        Prop.SetValue(obj, qry.FieldByName(prop.Name).AsInteger);
      tkUString,
      tkLString,
      tkString,
      tkWString:
         Prop.SetValue(obj, qry.FieldByName(prop.Name).AsString);
        tkFloat:
        begin
          if (Prop.PropertyType.Name = 'TDate') or (Prop.PropertyType.Name = 'TDateTime') then
            Prop.SetValue(obj, qry.FieldByName(prop.Name).AsDateTime)
          else
            Prop.SetValue(obj, qry.FieldByName(prop.Name).AsCurrency)
        end;
    end;
  end;
  Result := obj;
end;

end.
