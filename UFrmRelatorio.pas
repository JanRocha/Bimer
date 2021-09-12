unit UFrmRelatorio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  UUsuarios, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.DateTimeCtrls, FMX.Edit,
  FMX.ListBox,

  UFuncionarios,
  UFuncoes,
  UTabela
  ;

type
  TfrmRelatorio = class(TForm)
    Label1: TLabel;
    Rectangle1: TRectangle;
    Label2: TLabel;
    cmbLogin: TComboBox;
    cmbFuncao: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dtInicial: TDateEdit;
    dtFinal: TDateEdit;
    Rectangle3: TRectangle;
    btnImprimir: TSpeedButton;
    Rectangle2: TRectangle;
    SpeedButton1: TSpeedButton;
    SG: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FUsuario: TUsuarios;
    { Private declarations }
  public
    { Public declarations }
    property Usuario: TUsuarios read FUsuario write FUsuario;
  end;

var
  frmRelatorio: TfrmRelatorio;

implementation

uses
  System.Generics.Collections, Data.SqlExpr;

{$R *.fmx}

procedure TfrmRelatorio.FormShow(Sender: TObject);
var
 oFuncionarios  : TFuncionarios;
 lstFuncionarios: TObjectList<TFuncionarios>;
 i:integer;
 ofuncao   : TFuncoes;
 lstFuncao : TObjectList<TFuncoes>;
begin
  dtInicial.Date:= now;
  dtFinal.Date  := now;
  ofuncao       := TFuncoes.Create();
  oFuncionarios := TFuncionarios.Create();
  try
    lstFuncionarios := oFuncionarios.Carregar();
    lstFuncao       := ofuncao.Carregar();
    cmbLogin.Items.Add('Todos');
    cmbLogin.ItemIndex := 0;
    cmbFuncao.Items.Add('Todos');
    cmbFuncao.ItemIndex:= 0;
    for i :=0 to lstFuncionarios.Count -1 do
    begin
      cmbLogin.Items.Add(lstFuncionarios[i].Login);
    end;
    for i :=0 to lstFuncao.Count -1 do
    begin
      cmbFuncao.Items.Add(lstFuncao[i].Descricao);
    end;

  finally
    ofuncao.Free;
    oFuncionarios.Free;
  end;
end;

procedure TfrmRelatorio.SpeedButton1Click(Sender: TObject);
var
  qry    : TSQLQuery;
  oTabela: TTabela;
  s      : string;
  i: Integer;
begin
  SG.RowCount:= 0;
  s:= 'SELECT                                               ';
  s:= s + ' F.LOGIN,                                        ';
  s:= s + ' T.DESCRICAO AS TIPO,                            ';
  s:= s + ' H.DESCRICAO,                                    ';
  s:= s + ' H.DATA_HISTORICO                                ';
  s:= s + '   FROM FUNCIONARIOS F                           ';
  s:= s + '   JOIN FUNCOES FU ON FU.ID = F.ID_FUNCAO         ';
  s:= s + '   JOIN HISTORICO H ON H.ID_FUNCIONARIO = F.ID   ';
  s:= s + '   JOIN TIPOS T ON T.ID = H.ID_TIPO              ';
  s:= s + ' WHERE 1=1 ';

  if cmbLogin.ItemIndex > 0 then
    s:= s + ' AND F.LOGIN = ' + QuotedStr(cmbLogin.Items[cmbLogin.ItemIndex]);
  if cmbFuncao.ItemIndex > 0 then
    s:= s + ' AND FU.DESCRICAO = ' + QuotedStr(cmbFuncao.Items[cmbFuncao.ItemIndex]);

  s:= s + ' AND  H.DATA_HISTORICO BETWEEN '+ QuotedStr(FormatDateTime('dd.mm.yyyy', dtInicial.date));
  s:= s + ' AND ' + QuotedStr(FormatDateTime('dd.mm.yyyy', dtFinal.date));
  oTabela:= TTabela.Create;
  try
    qry:= oTabela.Open(s);
    i:= 0;
    while not qry.Eof do
    begin
      SG.RowCount := i + 1;
      SG.Cells[0,i]:= qry.FieldByName('LOGIN').AsString;
      SG.Cells[1,i]:= qry.FieldByName('TIPO').AsString;
      SG.Cells[2,i]:= qry.FieldByName('DESCRICAO').AsString;
      SG.Cells[3,i]:= qry.FieldByName('DATA_HISTORICO').AsString;
      inc(i);

      qry.Next;
    end;
  finally
    oTabela.Free;
  end;
end;

end.
