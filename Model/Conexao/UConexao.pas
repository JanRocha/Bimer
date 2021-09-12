unit UConexao;

interface

uses
  Classes,
  WideStrings,
  DBXFirebird,
  DB,
  SqlExpr,
  FMTBcd,
  DBClient,
  Provider,
  UFuncao,
  UConfigDB;

type
  TConexao = class(TPersistent)
  private
    FFuncao: TFuncao;
    FConfig: TConfigDB;
    Fconn: TSQLConnection;
    Fsql: TSQLQuery;
  published
    property conn: TSQLConnection read Fconn write Fconn;
    property sql: TSQLQuery read Fsql write Fsql;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TConexao }

constructor TConexao.Create;
begin
  conn    := TSQLConnection.Create(nil);
  sql     := TSQLQuery.Create(nil);
  FFuncao := TFuncao.Create;
  sql.SQLConnection:= conn;
  FConfig := TConfigDB.Create;
  conn.ConnectionName:= 'FBConnection';
  conn.DriverName    := 'Firebird';
  conn.Params.Add('Database='+FConfig.ip_servidor +'/'+ FConfig.porta + ':' + FConfig.DB);
  conn.Params.Add('RoleName=RoleName');
  conn.Params.Add('User_Name=sysdba');
  conn.Params.Add('Password=masterkey');
  conn.Params.Add('ServerCharSet=');
  conn.Params.Add('SQLDialect=3');
  conn.Params.Add('ErrorResourceFile=');
  conn.Params.Add('LocaleCode=0000');
  conn.Params.Add('BlobSize=-1');
  conn.Params.Add('CommitRetain=False');
  conn.Params.Add('WaitOnLocks=True');
  conn.Params.Add('IsolationLevel=ReadCommitted');
  conn.Params.Add('Trim Char=False');
  conn.LoginPrompt:= False;
  try
    conn.Connected:= true;
  except on E: Exception do
    FFuncao.GravarLog('constructor TConexao.Create: ' + E.Message);
  end;

end;

destructor TConexao.Destroy;
begin
  conn.Connected := False;
  FFuncao.Free;
  conn.Free;
  sql.Free;
  FConfig.Free;
  inherited;
end;

end.
