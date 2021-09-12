unit UFrmFuncionarioCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.DateTimeCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects,

  UFuncionarios,
  UFuncaoSistema,
  UFuncoes;

type
  TfrmFuncionarioCadastro = class(TForm)
    Rectangle1: TRectangle;
    edtLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtNome: TEdit;
    Label3: TLabel;
    edtSalario: TEdit;
    dtAdmissao: TDateEdit;
    dtDesligamento: TDateEdit;
    cmbFuncao: TComboBox;
    memoObservacao: TMemo;
    Rectangle3: TRectangle;
    btnEntrar: TSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtFoto: TSpeedButton;
    Rectangle2: TRectangle;
    SpeedButton2: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtFotoClick(Sender: TObject);
  private
    FFoto:string;
    F: TFuncaoSistema;
    FCodigo: integer;
  protected
    { Private declarations }
  public
    { Public declarations }
    property Codigo: integer read FCodigo write FCodigo;
    procedure carregarCombo();
  end;

var
  frmFuncionarioCadastro: TfrmFuncionarioCadastro;

implementation

uses
  System.Generics.Collections;

{$R *.fmx}

procedure TfrmFuncionarioCadastro.btnEntrarClick(Sender: TObject);
var
  oFuncionario: TFuncionarios;
begin
  if edtNome.Text = '' then
  begin
    F.MostrarMsgUsuario('Nome não informado');
    edtNome.SetFocus;
  end;
  if edtLogin.Text = '' then
  begin
    F.MostrarMsgUsuario('login não informado');
    edtLogin.SetFocus;
  end;
  if cmbFuncao.Items.Text = '' then
  begin
    F.MostrarMsgUsuario('Função não informado');
    cmbFuncao.SetFocus;
  end;
  if edtSalario.Text = '' then
  begin
    F.MostrarMsgUsuario('Salario não informado');
    edtSalario.SetFocus;
  end;

  oFuncionario := TFuncionarios.Create(Codigo);
  try
    oFuncionario.Nome          := edtNome.Text;
    oFuncionario.Login         := edtLogin.Text;
    oFuncionario.Id_funcao     := integer(cmbFuncao.Items.Objects[cmbFuncao.ItemIndex]);
    oFuncionario.Observacao    := memoObservacao.Lines.Text;
    oFuncionario.Data_admissao := dtAdmissao.Date;
    oFuncionario.Salario       := StrToCurr(edtSalario.Text);
    oFuncionario.Foto          := FFoto;
    oFuncionario.Ativo         := 1;
    oFuncionario.Gravar();
  finally
    oFuncionario.Free;
  end;
  Close();
end;

procedure TfrmFuncionarioCadastro.carregarCombo;
var
  oFuncoes: TFuncoes;
  lstFuncoes: TobjectList<TFuncoes>;
  i: integer;
begin
  oFuncoes := TFuncoes.Create();
  try
    lstFuncoes := oFuncoes.Carregar();
    for i := 0 to lstFuncoes.Count - 1 do
    begin
      cmbFuncao.Items.AddObject(lstFuncoes[i].Descricao,
        TObject(lstFuncoes[i].Id));
    end;
  finally
    oFuncoes.Free;
  end;
end;

procedure TfrmFuncionarioCadastro.edtFotoClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FFoto:= OpenDialog1.FileName;
  end;
end;

procedure TfrmFuncionarioCadastro.FormCreate(Sender: TObject);
begin
  carregarCombo();
  F:= TFuncaoSistema.Create;
end;

procedure TfrmFuncionarioCadastro.FormDestroy(Sender: TObject);
begin
  F.Free;
end;

procedure TfrmFuncionarioCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 27 then
    Close;
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
end;

procedure TfrmFuncionarioCadastro.FormShow(Sender: TObject);
var
  oFuncionario: TFuncionarios;
begin
  if Codigo > 0 then
  begin
    oFuncionario := TFuncionarios.Create(Codigo);
    try
      edtLogin.Text             := oFuncionario.Login;
      edtNome.Text              := oFuncionario.Nome;
      edtSalario.Text           := CurrToStr(oFuncionario.Salario);
      cmbFuncao.ItemIndex       := cmbFuncao.Items.IndexOfObject(TObject(oFuncionario.Id_funcao));
      memoObservacao.Lines.Text := oFuncionario.Observacao;
      dtAdmissao.Date           := oFuncionario.Data_admissao;
      dtDesligamento.Date       := oFuncionario.Data_demissao;
    finally
      oFuncionario.Free;
    end;
  end;
end;

procedure TfrmFuncionarioCadastro.SpeedButton2Click(Sender: TObject);
begin
  Close();
end;

end.
