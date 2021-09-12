unit UFuncoes;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,            
  Data.SqlExpr,               
  UTabela;                    

type
  TFuncoes = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FDescricao: String;
    FAtivo: String;
  published
    property Id: integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
    property Ativo: String read FAtivo write FAtivo;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(): TObjectList<TFuncoes>;
   function Gravar(): boolean;                   
   function Delete(): boolean;                   
   function NomeGenerator(): string;             
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{TFuncoes}

constructor TFuncoes.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM FUNCOES';            
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

constructor TFuncoes.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM FUNCOES'; 
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

function TFuncoes.NomeTabela(): string;
begin
  Result:= 'Funcoes';
end;

function TFuncoes.Carregar(): TObjectList<TFuncoes>;
var
  FTabela: TTabela;
  oFuncoes:TFuncoes;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<TFuncoes>.Create; 
  sSQL:= 'SELECT * FROM FUNCOES ORDER BY ID';
  FTabela              := TTabela.Create; 
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oFuncoes   := TFuncoes.Create;  
      FTabela.Classe := oFuncoes;        
      FTabela.SerializarObjeto(oqry, oFuncoes);
      Result.Add(oFuncoes);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function TFuncoes.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM FUNCOES WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function TFuncoes.Gravar(): boolean;
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

function TFuncoes.NomeGenerator(): string;
begin
  Result:= 'GEN_FUNCOES_ID';
end;

function TFuncoes.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.