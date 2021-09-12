unit UFuncionarios;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,            
  Data.SqlExpr,               
  UTabela;                    

type
  TFuncionarios = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FNome: String;
    FLogin: String;
    FFoto: String;
    FId_funcao: integer;
    FSalario: Currency;
    FData_admissao: TDate;
    FData_demissao: TDate;
    FObservacao: String;
    FAtivo: integer;
  published
    property Id: integer read FId write FId;
    property Nome: String read FNome write FNome;
    property Login: String read FLogin write FLogin;
    property Foto: String read FFoto write FFoto;
    property Id_funcao: integer read FId_funcao write FId_funcao;
    property Salario: Currency  read FSalario write FSalario;
    property Data_admissao: TDate read FData_admissao write FData_admissao;
    property Data_demissao: TDate read FData_demissao write FData_demissao;
    property Observacao: String read FObservacao write FObservacao;
    property Ativo: integer read FAtivo write FAtivo;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(): TObjectList<TFuncionarios>;
   function Gravar(): boolean;
   function Delete(): boolean;
   function NomeGenerator(): string;
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{TFuncionarios}

constructor TFuncionarios.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM FUNCIONARIOS';            
    sSQL    := sSQL + ' WHERE ID = ' + IntToStr(_id); 
    sSQL    := sSQL + ' ORDER BY ID';                 
    FTabela := TTabela.Create;              
    try                                     
      oqry:= FTabela.Open(sSQL);            
      FTabela.SerializarObjeto(oqry, Self); 
    finally          
      FTabela.Free;  
    end;       
  end          
  else         
    ID := -1;  
end;

constructor TFuncionarios.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM FUNCIONARIOS'; 
    sSQL    := sSQL + _Filter;                           
    sSQL    := sSQL + ' ORDER BY ID';     
    FTabela := TTabela.Create;                           
    try                                     
      oqry:= FTabela.Open(sSQL);            
      FTabela.SerializarObjeto(oqry, Self); 
    finally                
     FTabela.Free;         
   end;                    
  end                      
  else                     
    ID:= -1;  
end;                       

function TFuncionarios.NomeTabela(): string;
begin
  Result:= 'Funcionarios';
end;

function TFuncionarios.Carregar(): TObjectList<TFuncionarios>;
var
  FTabela: TTabela;
  oFuncionarios:TFuncionarios;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<TFuncionarios>.Create; 
  sSQL:= 'SELECT * FROM FUNCIONARIOS ORDER BY ID';
  FTabela              := TTabela.Create; 
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oFuncionarios   := TFuncionarios.Create;  
      FTabela.Classe := oFuncionarios;        
      FTabela.SerializarObjeto(oqry, oFuncionarios);
      Result.Add(oFuncionarios);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function TFuncionarios.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM FUNCIONARIOS WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function TFuncionarios.Gravar(): boolean;
var                                             
  sSQL: string;                                 
begin                                           
  Result  := True;
  FTabela := TTabela.Create();                  
  try                                           
    FTabela.Classe     := Self;                 
    FTabela.NomeTabela := NomeTabela;           
    if  ID <= 0 then                            
    begin                                       
      ID   := FTabela.GetNewID(NomeGenerator);  
      sSQL := FTabela.PrepararInsert();         
    end                                         
    else                                        
      sSQL := FTabela.PrepararUpdate();         
    FTabela.ExecutarSQL(sSQL);                  
  finally         
    FTabela.free; 
  end; 
end;

function TFuncionarios.NomeGenerator(): string;
begin
  Result:= 'GEN_FUNCIONARIOS_ID';
end;

function TFuncionarios.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.