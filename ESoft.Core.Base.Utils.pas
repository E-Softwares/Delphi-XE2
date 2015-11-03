Unit ESoft.Core.Base.Utils;

Interface

Uses
  Windows,
  System.Classes,
  System.SysUtils,
  ShellApi,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IniFiles,
  Vcl.Dialogs,
  Vcl.Controls,
  BackgroundWorker,
  Registry,
  ESoft.Utils;

Type
  TEDownloader = Class(TInterfacedPersistent)
  Strict Private
    FOwner: TComponent;
    FTaskDialog: TTaskDialog;
    FBackGnd: TBackgroundWorker;
    FURL: String;
    FFileName: String;

    Function GetBackGndWorker: TBackgroundWorker;
    Function GetTaskDialog: TTaskDialog;
    Procedure Initialize;
    Procedure TaskButtonClicked(
      Sender: TObject;
      ModalResult: TModalResult;
      Var CanClose: Boolean);
    Procedure BackGndWorkerWorkComplete(
      Worker: TBackgroundWorker;
      Cancelled: Boolean);
    Procedure BackGndWorkerWork(Worker: TBackgroundWorker);

  Public
    Constructor Create(Const aOwner: TComponent);
    Destructor Destroy; Override;

    Function Download: Boolean;

  Published
    Property URL: String Read FURL Write FURL;
    Property FileName: String Read FFileName Write FFileName;
    Property TaskDialog: TTaskDialog Read GetTaskDialog;
    Property BackGndWorker: TBackgroundWorker Read GetBackGndWorker;
  End;

Implementation

{TEDownloader}

Constructor TEDownloader.Create(Const aOwner: TComponent);
Begin
  Assert(Assigned(aOwner));
  FOwner := aOwner;

  Initialize;
End;

Destructor TEDownloader.Destroy;
Begin
  EFreeAndNil(FTaskDialog);
  EFreeAndNil(FBackGnd);

  Inherited;
End;

Function TEDownloader.Download: Boolean;
Begin
  Assert(URL <> '', 'URL not set');
  Assert(FileName <> '', 'FileName not set');

  BackGndWorker.Execute;
  TaskDialog.Execute;
End;

Function TEDownloader.GetBackGndWorker: TBackgroundWorker;
Begin
  If Not Assigned(FBackGnd) Then
    FBackGnd := TBackgroundWorker.Create(FOwner);
  Result := FBackGnd;
End;

Function TEDownloader.GetTaskDialog: TTaskDialog;
Begin
  If Not Assigned(FTaskDialog) Then
    FTaskDialog := TTaskDialog.Create(FOwner);
  Result := FTaskDialog;
End;

Procedure TEDownloader.TaskButtonClicked(
  Sender: TObject;
  ModalResult: TModalResult;
  Var CanClose: Boolean);
Begin
  ModalResult := mrOk;
End;

Procedure TEDownloader.BackGndWorkerWork(Worker: TBackgroundWorker);
Var
  varFileStream: TFileStream;
  varHttp: TIdHTTP;
Begin
  varFileStream := TFileStream.Create(FileName, fmCreate);
  varHttp := TIdHTTP.Create;
  Try
    varHttp.Get(URL, varFileStream);
  Finally
    varHttp.Free;
    varFileStream.Free;
  End;
End;

Procedure TEDownloader.BackGndWorkerWorkComplete(
  Worker: TBackgroundWorker;
  Cancelled: Boolean);
Begin
  TaskDialog.Buttons[0].Click;
End;

Procedure TEDownloader.Initialize;
Begin
  TaskDialog.Caption := 'ESoft application downloader';
  TaskDialog.Title := 'Downloading application';
  TaskDialog.Text := 'Please wait . . . ';
  With TaskDialog.Buttons.Add Do
  Begin
    Caption := 'Close';
    Enabled := False;
  End;
  TaskDialog.CommonButtons := [];
  TaskDialog.Flags := TaskDialog.Flags + [tfShowMarqueeProgressBar] - [tfAllowDialogCancellation];
  TaskDialog.OnButtonClicked := TaskButtonClicked;

  BackGndWorker.OnWork := BackGndWorkerWork;
  BackGndWorker.OnWorkComplete := BackGndWorkerWorkComplete;
End;

End.
