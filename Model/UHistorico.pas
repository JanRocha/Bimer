unit UHistorico;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,
  Data.SqlExpr,
  UTabela;

type
  THistorico = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FDescricao: String;
    FId_tipo: integer;
    FId_funcionario: integer;
    FData_historico: Tdatetime;
  published
    property Id: integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
    property Id_tipo: integer read FId_tipo write FId_tipo;
    property Id_funcionario: integer read FId_funcionario write FId_funcionario;
    property Data_historico: Tdatetime read FData_historico write FData_historico;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(_Filter:string = ''): TObjectList<THistorico>;
   function Gravar(): boolean;
   function Delete(): boolean;                   
   function NomeGenerator(): string;             
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{THistorico}

constructor THistorico.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM HISTORICO';            
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

constructor THistorico.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM HISTORICO'; 
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

function THistorico.NomeTabela(): string;
begin
  Result:= 'Historico';
end;

function THistorico.Carregar(_Filter:string): TObjectList<THistorico>;
var
  FTabela: TTabela;
  oHistorico:THistorico;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<THistorico>.Create;
  if _Filter = '' then
    sSQL:= 'SELECT * FROM HISTORICO ORDER BY ID'
  else
    sSQL:= 'SELECT * FROM HISTORICO WHERE ' + _Filter;
  FTabela              := TTabela.Create;
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oHistorico   := THistorico.Create;  
      FTabela.Classe := oHistorico;        
      FTabela.SerializarObjeto(oqry, oHistorico);
      Result.Add(oHistorico);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function THistorico.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM HISTORICO WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function THistorico.Gravar(): boolean;
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

function THistorico.NomeGenerator(): string;
begin
  Result:= 'GEN_HISTORICO_ID';
end;

function THistorico.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.