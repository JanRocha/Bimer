unit UUsuarios;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,            
  Data.SqlExpr,               
  UTabela;                    

type
  TUsuarios = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FNome: String;
    FLogin: String;
    FSenha: String;
  published
    property Id: integer read FId write FId;
    property Nome: String read FNome write FNome;
    property Login: String read FLogin write FLogin;
    property Senha: String read FSenha write FSenha;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(): TObjectList<TUsuarios>;
   function Gravar(): boolean;                   
   function Delete(): boolean;                   
   function NomeGenerator(): string;             
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{TUsuarios}

constructor TUsuarios.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM USUARIOS';            
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

constructor TUsuarios.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM USUARIOS'; 
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

function TUsuarios.NomeTabela(): string;
begin
  Result:= 'Usuarios';
end;

function TUsuarios.Carregar(): TObjectList<TUsuarios>;
var
  FTabela: TTabela;
  oUsuarios:TUsuarios;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<TUsuarios>.Create; 
  sSQL:= 'SELECT * FROM USUARIOS ORDER BY ID';
  FTabela              := TTabela.Create; 
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oUsuarios   := TUsuarios.Create;  
      FTabela.Classe := oUsuarios;        
      FTabela.SerializarObjeto(oqry, oUsuarios);
      Result.Add(oUsuarios);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function TUsuarios.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM USUARIOS WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function TUsuarios.Gravar(): boolean;
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

function TUsuarios.NomeGenerator(): string;
begin
  Result:= 'GEN_USUARIOS_ID';
end;

function TUsuarios.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.