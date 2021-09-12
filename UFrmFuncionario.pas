unit UFrmFuncionario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, FMX.Edit,
  System.Generics.Collections,

  UUsuarios,
  UFuncionarios,
  UFrmParecer,
  UFrmFuncionarioCadastro
  ;

type
  TfrmFuncionario = class(TForm)
    Label1: TLabel;
    Rectangle1: TRectangle;
    SG: TStringGrid;
    Rectangle3: TRectangle;
    btnAdicionar: TSpeedButton;
    Edit1: TEdit;
    SGCodigo: TStringColumn;
    SGLogin: TStringColumn;
    SGNome: TStringColumn;
    SGFuncao: TStringColumn;
    SGAdmissao: TColumn;
    SGEditar: TStringColumn;
    SGExcluir: TStringColumn;
    SGParecer: TStringColumn;
    procedure CarregarGrid();
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    FUsuario: TUsuarios;
    FFuncionarios: TObjectList<TFuncionarios>;
  public
    property Usuario: TUsuarios read FUsuario write FUsuario;
  end;

var
  frmFuncionario: TfrmFuncionario;

implementation

uses
  UFuncoes;

{$R *.fmx}

{ TfrmFuncionario }


procedure TfrmFuncionario.btnAdicionarClick(Sender: TObject);
var
  frm: TfrmFuncionarioCadastro;
begin
  frm:= TfrmFuncionarioCadastro.Create(nil);
  try
    self.Visible:= false;
    frm.Parent:= frm.Parent;
    frm.ShowModal;
    self.Visible:= true;
  finally
    frm.Free;
  end;
  CarregarGrid();
end;

procedure TfrmFuncionario.CarregarGrid;
var
  FFunc: TFuncionarios;
  Funcao: TFuncoes;
  i:integer;
begin
  FFunc:= TFuncionarios.Create;
  try
    FFuncionarios := FFunc.Carregar();
    SG.RowCount   := FFuncionarios.Count;

    for i := 0 to FFuncionarios.Count -1 do
    begin
      SG.Cells[0,i]:= IntToStr(FFuncionarios.Items[i].Id);
      SG.Cells[1,i]:= FFuncionarios.Items[i].Login;
      SG.Cells[2,i]:= FFuncionarios.Items[i].Nome;
      Funcao:= TFuncoes.Create(FFuncionarios.Items[i].Id_funcao);
      try
        SG.Cells[3,i]:= Funcao.Descricao;  
      finally
        Funcao.Free;
      end;
      SG.Cells[4,i]:= DateToStr(FFuncionarios.Items[i].Data_admissao);
      SG.Cells[5,i]:= 'Editar';
      SG.Cells[6,i]:= 'Excluir';
      SG.Cells[7,i]:= 'Parecer';
    end;
  finally
    FFunc.Free;
  end;
end;

procedure TfrmFuncionario.FormCreate(Sender: TObject);
begin
  CarregarGrid();
end;

procedure TfrmFuncionario.SGSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  frm         : TfrmFuncionarioCadastro;
  oFuncionario: TFuncionarios;
  frmParece   : TfrmParecer;
begin
  if ACol = 5 then
    begin
    frm:= TfrmFuncionarioCadastro.Create(nil);
    try
      self.Visible:= false;
      frm.Parent:= self.Parent;
      frm.Codigo:= StrToInt(SG.Cells[0,ARow]);
      frm.ShowModal;
      self.Visible:= true;
    finally
      frm.Free;
    end;
    CarregarGrid();
  end;
  if ACol = 6 then
  begin
    oFuncionario:= TFuncionarios.Create(StrToInt(SG.Cells[0,ARow]));
    try
      oFuncionario.Ativo:= 0;
      oFuncionario.Gravar;
    finally
      oFuncionario.Free;
    end;
    CarregarGrid();
  end;
  if ACol = 7 then
  begin
    frmParece:= TfrmParecer.Create(nil);
    try
      self.Visible:= false;
      frmParece.Parent:= self.Parent;
      frmParece.Codigo:= StrToInt(SG.Cells[0,ARow]);
      frmParece.ShowModal;
      self.Visible:= true;
    finally
      frmParece.Free;
    end;
    CarregarGrid();
  end;

end;

end.
