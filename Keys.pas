unit Keys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SBPGPKeys;

type
  TfrmPrivateKeys = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lstKeys: TListBox;
    lblPrompt: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
