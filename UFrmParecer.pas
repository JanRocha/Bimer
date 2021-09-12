unit UFrmParecer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.ListBox, FMX.Edit,
  UTipos,
  UHistorico,
  UFuncionarios,
  UFrmParecerHistorico
  ;

type
  TfrmParecer = class(TForm)
    Rectangle1: TRectangle;
    lblCodigo: TLabel;
    lblLogin: TLabel;
    lblAdmissao: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtTitulo: TEdit;
    cboTipos: TComboBox;
    dtLancamento: TDateEdit;
    MemoDescricao: TMemo;
    Rectangle3: TRectangle;
    btnAdicionar: TSpeedButton;
    Rectangle2: TRectangle;
    SpeedButton2: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
  private
    FFuncionario: TFuncionarios;
    FCodigo: integer;
    { Private declarations }
  public
    property Codigo: integer read FCodigo write FCodigo;
    procedure carregarCombo();
  end;

var
  frmParecer: TfrmParecer;

implementation

uses
  System.Generics.Collections;

{$R *.fmx}

{ TfrmParecer }

procedure TfrmParecer.btnAdicionarClick(Sender: TObject);
var
  oHistorico: THistorico;
  frm: TfrmParecerHistorico;
begin
  oHistorico:= THistorico.Create();
  try
    oHistorico.Descricao      := MemoDescricao.Lines.Text;
    oHistorico.Id_tipo        := Integer(cboTipos.Items.Objects[cboTipos.ItemIndex]);
    oHistorico.Id_funcionario     := codigo;
    oHistorico.Data_historico := dtLancamento.Date;
    oHistorico.Gravar();
  finally
    oHistorico.Free;
  end;
  frm:= TfrmParecerHistorico.Create(nil);
  try
    self.Hide;
    frm.Parent:= Self.Parent;
    frm.Codigo:= Codigo;
    frm.ShowModal;
  finally
    frm.Free;
  end;
  close();
end;

procedure TfrmParecer.carregarCombo;
var
  i       : integer;
  oTipos  : TTipos;
  lstTipos: TObjectList<TTipos>;
begin
  oTipos:= TTipos.Create();
  lstTipos:= oTipos.Carregar();
  try
    for i := 0to lstTipos.Count -1 do
    begin
      cboTipos.Items.AddObject(lstTipos[i].Descricao, TObject(lstTipos[i].Id));
    end;
  finally
    lstTipos.Free;
    oTipos.Free;
  end;
end;

procedure TfrmParecer.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = 27 then
    close;
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
end;

procedure TfrmParecer.FormShow(Sender: TObject);
begin
  FFuncionario:= TFuncionarios.Create(codigo);
  try
    lblCodigo.Text   := '  Código: ' + IntToStr(FFuncionario.Id);
    lblLogin.Text    := '   Login: ' + FFuncionario.Login;
    lblAdmissao.Text := 'Admissão: ' + DateToStr(FFuncionario.Data_admissao);
  finally
    FFuncionario.Free;
  end;
  carregarCombo();
  dtLancamento.Date:= now;
end;

end.
