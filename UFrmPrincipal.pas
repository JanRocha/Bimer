unit UFrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList,
  FMX.ImgList,
  Winapi.Windows, 
  FMX.Dialogs,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Objects,
  UFuncaoSistema,
  UUsuarios,
  uFrmFuncionario,
  UFrmDashBoard,
  UFrmRelatorio
  ;

type
  TfrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    RecMenu: TRectangle;
    ImageList1: TImageList;
    Rectangle2: TRectangle;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lblUsuario: TLabel;
    btnDashboard: TSpeedButton;
    btnRelatorio: TSpeedButton;
    btnFuncionario: TSpeedButton;
    Panel1: TPanel;
    RecPrincipal: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnFuncionarioClick(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FrmFuncionario: TfrmFuncionario;
    FUsuario: TUsuarios;
    FrmDashboard: TfrmDashboard;
    Frmrelatorio: TfrmRelatorio;
    procedure VerificarForms();
  public
    FFuncao: TFuncaoSistema;
    property Usuario: TUsuarios read FUsuario write FUsuario;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FFuncao := TFuncaoSistema.Create;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FFuncao.Free;
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  RecPrincipal.Position := Panel1.Position;
  RecPrincipal.Width    := Panel1.Width;
  RecPrincipal.Height   := Panel1.Height;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  self.Height := self.Height - FFuncao.Rodape();
  lblUsuario.Text:= 'Olá ,' + Usuario.Login;
  btnDashboardClick(btnDashboard);
end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
 if MessageDlg('Deseja sair do sistema?',TMsgDlgType.mtwarning,[TMsgDlgBtn.mbNo,TMsgDlgBtn.mbYes],0) = mrYes then
   close;
end;

procedure TfrmPrincipal.btnDashboardClick(Sender: TObject);
begin
  VerificarForms();
  FrmDashboard:= TfrmDashboard.Create(self);
  FrmDashboard.Parent := Panel1;
  FrmDashboard.Usuario:= Usuario;
  FrmDashboard.Height := Round(Panel1.Height);
  FrmDashboard.Width  := Round(Panel1.Width);
  FrmDashboard.Top    := Round(Panel1.Position.Y);
  FrmDashboard.Left   := Round(Panel1.Position.X);
  FrmDashboard.Show;
end;

procedure TfrmPrincipal.btnRelatorioClick(Sender: TObject);
begin
  VerificarForms();
  Frmrelatorio:= TfrmRelatorio.Create(self);
  Frmrelatorio.Parent := Panel1;
  Frmrelatorio.Usuario:= Usuario;
  Frmrelatorio.Height := Round(Panel1.Height);
  Frmrelatorio.Width  := Round(Panel1.Width);
  Frmrelatorio.Top    := Round(Panel1.Position.Y);
  Frmrelatorio.Left   := Round(Panel1.Position.X);
  Frmrelatorio.Show;
end;

procedure TfrmPrincipal.btnFuncionarioClick(Sender: TObject);
begin
  VerificarForms();
  FrmFuncionario:= TfrmFuncionario.Create(self);
  FrmFuncionario.Parent := Panel1;
  FrmFuncionario.Usuario:= Usuario;
  FrmFuncionario.Height := Round(Panel1.Height);
  FrmFuncionario.Width  := Round(Panel1.Width);
  FrmFuncionario.Top    := Round(Panel1.Position.Y);
  FrmFuncionario.Left   := Round(Panel1.Position.X);
  FrmFuncionario.Show;
end;

procedure TfrmPrincipal.VerificarForms;
begin
  if Assigned(FrmFuncionario) then
  begin
    FrmFuncionario.Free;
    FrmFuncionario:= nil;
  end;
  if Assigned(Frmrelatorio) then
  begin
    Frmrelatorio.Free;
    Frmrelatorio:= nil;
  end;
  if Assigned(FrmDashboard) then
  begin
     FrmDashboard.free;
     FrmDashboard:= nil;
  end;
end;

end.
