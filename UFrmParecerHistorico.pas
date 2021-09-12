unit UFrmParecerHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.ListBox, FMX.Edit,
  UTipos,
  UHistorico,
  UFuncionarios, FMX.Layouts
  ;

type
  TfrmParecerHistorico = class(TForm)
    Rectangle1: TRectangle;
    lblCodigo: TLabel;
    lblLogin: TLabel;
    lblAdmissao: TLabel;
    Rectangle2: TRectangle;
    SpeedButton2: TSpeedButton;
    ScrollBox1: TScrollBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FFuncionario: TFuncionarios;
    FCodigo: integer;
    procedure CreatePanel(Y:integer; data, tipo, descricao:string );
    { Private declarations }
  public
    property Codigo: integer read FCodigo write FCodigo;
  end;

var
  frmParecerHistorico: TfrmParecerHistorico;

implementation

uses
  System.Generics.Collections, Winapi.Windows;

{$R *.fmx}

{ TfrmParecer }


procedure TfrmParecerHistorico.CreatePanel(Y:integer; data, tipo, descricao:string);
var
  pnl: TPanel;
  Rec: TRectangle;
  lblDestaque,
  lblData,
  lblDescricao: TLabel;
begin
  pnl:=  TPanel.Create(nil);
  pnl.Position.X           := 20;
  pnl.Position.Y           := Y;
  pnl.Size.Width           := 500;
  pnl.Size.Height          := 150;
  pnl.Size.PlatformDefault := False;
  pnl.TabOrder             := 0;
  pnl.Parent               := ScrollBox1;
  Rec                      := TRectangle.Create(nil);
  rec.Parent               := pnl;
  Rec.Fill.Color           := $FF788896;
  Rec.Margins.Left         := 10;
  Rec.Margins.Right        := 10;
  Rec.Position.X           := 6;;
  Rec.Position.Y           := 72;
  Rec.Size.Width           := 488;
  Rec.Size.Height          := 2;
  Rec.Size.PlatformDefault := False;
  //Rec.Stroke.Kind          := None;

  lblDestaque:= TLabel.Create(nil);
  lblDestaque.parent         := pnl;
 //lblDestaque.StyledSettings := [Style];
  lblDestaque.Position.X               := 7;
  lblDestaque.Position.Y               := 22;
  lblDestaque.Size.Width               := 495;
  lblDestaque.Size.Height              := 45;
  lblDestaque.Size.PlatformDefault     := False;
  lblDestaque.TextSettings.Font.Family := 'Cambria';
  lblDestaque.TextSettings.Font.Size   := 20;
  lblDestaque.TextSettings.FontColor   := $FF788896;
  lblDestaque.Text                     := 'Tipo: '+tipo;
  lblDestaque.TabOrder                 := 2;

  lblData:= TLabel.create(nil);
  lblData.Parent                   := pnl;
  //lblData.StyledSettings           := [Style];
  lblData.Position.X               := 6;
  lblData.Position.Y               := 3;
  lblData.Size.Width               := 481;
  lblData.Size.Height              := 33;
  lblData.Size.PlatformDefault     := False;
  lblData.TextSettings.Font.Family := 'Cambria';
  lblData.TextSettings.Font.Size   := 20;
  lblData.TextSettings.FontColor   := $FF788896;
  lblData.Text                     := 'Data: '+ data;
  lblData.TabOrder                 := 1;

  lblDescricao:= TLabel.Create(nil);
  lblDescricao.Parent                   := pnl;
  //lblDescricao.StyledSettings           := [Style];
  lblDescricao.Position.X               := 3;
  lblDescricao.Position.Y               := 81;
  lblDescricao.Size.Width               := 494;
  lblDescricao.Size.Height              := 64;
  lblDescricao.Size.PlatformDefault     := False;
  lblDescricao.TextSettings.Font.Family := 'Cambria';
  lblDescricao.TextSettings.Font.Size   := 20;
  lblDescricao.TextSettings.FontColor   := $FF788896;
  lblDescricao.Text                     := descricao;
  lblDescricao.TabOrder                 := 0;

end;

procedure TfrmParecerHistorico.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = 27 then
    close;
end;

procedure TfrmParecerHistorico.FormShow(Sender: TObject);
var
  i,x         : integer;
  oHistorico  : THistorico;
  oTipo       : TTipos;
  lstHistorico: TObjectList<THistorico>;
begin
  FFuncionario:= TFuncionarios.Create(codigo);
  try
    lblCodigo.Text   := '  Código: ' + IntToStr(FFuncionario.Id);
    lblLogin.Text    := '   Login: ' + FFuncionario.Login;
    lblAdmissao.Text := 'Admissão: ' + DateToStr(FFuncionario.Data_admissao);
  finally
    FFuncionario.Free;
  end;
  x:= 10;
  oHistorico:= THistorico.Create();
  try
    lstHistorico:= oHistorico.Carregar(' 1=1 AND ID_FUNCIONARIO = ' + IntToStr(FFuncionario.Id)+ ' ORDER BY DATA_HISTORICO DESC, ID DESC');
    for i := 0 to lstHistorico.Count -1 do
    begin
      oTipo:= TTipos.Create(lstHistorico[i].Id_tipo);
      try
        CreatePanel(x,DateToStr(lstHistorico[i].Data_historico),oTipo.Descricao,lstHistorico[i].Descricao);
      finally
        oTipo.Free;
      end;
      x:= x + 160;
    end;
  finally
    oHistorico.Free;
  end;

end;

procedure TfrmParecerHistorico.SpeedButton2Click(Sender: TObject);
begin
  close;
end;

end.
