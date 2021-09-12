unit UTipos;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,            
  Data.SqlExpr,               
  UTabela;                    

type
  TTipos = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FDescricao: String;
  published
    property Id: integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(): TObjectList<TTipos>;
   function Gravar(): boolean;                   
   function Delete(): boolean;                   
   function NomeGenerator(): string;             
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{TTipos}

constructor TTipos.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM TIPOS';            
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

constructor TTipos.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM TIPOS'; 
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

function TTipos.NomeTabela(): string;
begin
  Result:= 'Tipos';
end;

function TTipos.Carregar(): TObjectList<TTipos>;
var
  FTabela: TTabela;
  oTipos:TTipos;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<TTipos>.Create; 
  sSQL:= 'SELECT * FROM TIPOS ORDER BY ID';
  FTabela              := TTabela.Create; 
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oTipos   := TTipos.Create;  
      FTabela.Classe := oTipos;        
      FTabela.SerializarObjeto(oqry, oTipos);
      Result.Add(oTipos);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function TTipos.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM TIPOS WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function TTipos.Gravar(): boolean;
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

function TTipos.NomeGenerator(): string;
begin
  Result:= 'GEN_TIPOS_ID';
end;

function TTipos.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.