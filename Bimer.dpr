program Bimer;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFrmLogin in 'UFrmLogin.pas' {frmLogin},
  UConexao in 'Model\Conexao\UConexao.pas',
  UConfigDB in 'Model\Conexao\UConfigDB.pas',
  UFuncoes in 'Model\UFuncoes.pas',
  UHistorico in 'Model\UHistorico.pas',
  UTipos in 'Model\UTipos.pas',
  UTabela in 'Model\Conexao\UTabela.pas',
  UFuncaoSistema in 'UFuncaoSistema.pas',
  UFrmPrincipal in 'UFrmPrincipal.pas' {frmPrincipal},
  UFrmDashBoard in 'UFrmDashBoard.pas' {frmDashboard},
  UFrmRelatorio in 'UFrmRelatorio.pas' {frmRelatorio},
  UFrmFuncionario in 'UFrmFuncionario.pas' {frmFuncionario},
  UFuncionarios in 'Model\UFuncionarios.pas',
  UUsuarios in 'Model\UUsuarios.pas',
  UFrmFuncionarioCadastro in 'UFrmFuncionarioCadastro.pas' {frmFuncionarioCadastro},
  UFrmParecer in 'UFrmParecer.pas' {frmParecer},
  UFrmParecerHistorico in 'UFrmParecerHistorico.pas' {frmParecerHistorico};
  
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmFuncionario, frmFuncionario);
  Application.CreateForm(TfrmFuncionarioCadastro, frmFuncionarioCadastro);
  Application.CreateForm(TfrmParecer, frmParecer);
  Application.CreateForm(TfrmParecerHistorico, frmParecerHistorico);
  Application.CreateForm(TfrmParecerHistorico, frmParecerHistorico);
  Application.Run;
end.
