unit UFrmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  UUsuarios,
  UFrmPrincipal,
  UFuncaoSistema
  ;

type
  TfrmLogin = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    edtLogin: TEdit;
    edtSenha: TEdit;
    Label3: TLabel;
    Rectangle3: TRectangle;
    btnEntrar: TSpeedButton;
    Image1: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure edtSenhaKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

procedure TfrmLogin.edtSenhaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
 if Key = vkReturn then
  begin
    btnEntrarClick(btnEntrar);
  end;
end;

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = 27) then
    Application.Terminate;
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var  F: TFuncaoSistema;
begin
  F:= TFuncaoSistema.create;
  try
    Height := Screen.Height - F.Rodape();
  finally
    F.Free;
  end;

end;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
var
  oLogin: TUsuarios;
  F     : TFuncaoSistema;
  s:string;
begin
  F := TFuncaoSistema.Create;
  try
    if edtLogin.Text = '' then
    begin
      F.MostrarMsgUsuario('Login não informado');
      edtLogin.SetFocus;
      exit;
    end;
    if edtSenha.Text = '' then
    begin
      F.MostrarMsgUsuario('Senha não informada');
      edtSenha.SetFocus;
      exit;
    end;
    s:= 'LOGIN = '+ QuotedStr(edtLogin.Text) + ' AND SENHA = '+ QuotedStr(edtSenha.Text);
    oLogin:= TUsuarios.CreateFirst(s);
    try
      if oLogin.Id = 0 then
      begin
        F.MostrarMsgUsuario('Login não encontrado');
        edtLogin.SetFocus;
      end
      else
      begin
        frmPrincipal:= TfrmPrincipal.Create(nil);
        try
          frmPrincipal.Usuario:= oLogin;
          frmPrincipal.ShowModal;
        finally
          frmPrincipal.Free;
          Application.Terminate;
        end;
      end;
    finally
      oLogin.Free;
    end;
  finally
    F.Free;
  end;
end;

end.
