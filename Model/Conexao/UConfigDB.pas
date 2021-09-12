unit UConfigDB;

interface
   uses inifiles, classes, SysUtils;

type
   TConfigDB = Class(TPersistent)
   private
     Fip_servidor: string;
     FDB: string;
     Fporta: string;
     FLicensa: string;
     FDBAuxiliar: string;
   published
      property ip_servidor: string read Fip_servidor write Fip_servidor;
      property porta: string read Fporta write Fporta;
      property DB: string read FDB write FDB;
      property Licenca:string read FLicensa  write FLicensa;
      property DBAuxiliar: string read FDBAuxiliar write FDBAuxiliar;
   public
      procedure Gravar();
      constructor Create();
   End;
implementation

{ TConfigDB }

constructor TConfigDB.Create;
var
 oIni: TIniFile;
begin

   oIni:= TIniFile.Create(GetCurrentDir+'\Conexao.ini');
   try
      Fip_servidor := oIni.ReadString('CONEXAO','IP_SERVIDOR','');
      Fporta       := oIni.ReadString('CONEXAO','PORTA'      ,'');
      FDB          := oIni.ReadString('CONEXAO', 'RETAGUARDA','');
   finally
      oIni.Free;
   end;

   oIni:= TIniFile.Create(GetCurrentDir+'\COMANDA.ini');
   try
      Licenca      := oIni.ReadString('LICENCA', 'VALOR','');
      DBAuxiliar   := oIni.ReadString('CONEXAO', 'AZUL','');
   finally
      oIni.Free;
   end;

end;

procedure TConfigDB.Gravar;
var
 oIni: TIniFile;
begin
  oIni:= TIniFile.Create(GetCurrentDir+'\COMANDA.ini');
   try
      oIni.WriteString('LICENCA', 'VALOR',Licenca);
   finally
      oIni.Free;
   end;
end;

end.
