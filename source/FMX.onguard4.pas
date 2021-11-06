(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower OnGuard
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  ONGUARD4.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I onguard.inc}

unit FMX.onguard4;
  {-Product description dialog}

interface

uses
  {$IFDEF MSWINDOWS} Winapi.Windows, {$ENDIF}  FMX.ogutil,FMX. onguard, System.SysUtils,
  System.Types, System.UITypes, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Objects, FMX.ExtCtrls, FMX.Layouts, FMX.Edit, FMX.Platform,  Fmx.StdCtrls,
  FMX.Header, FMX.Graphics, FMX.Controls.Presentation;

type
  TEditProductFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    ProductEd: TEdit;
    Label2: TLabel;
    KeyEd: TEdit;
    GenerateKeySb: TSpeedButton;
    KeyPasteSb: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure InfoChanged(Sender: TObject);
    procedure KeyPasteSbClick(Sender: TObject);
    procedure GenerateKeySbClick(Sender: TObject);
  private
    { Private declarations }
    FKey         : TLbKey;
    FKeyType     : TKeyType;

    function GetShowHints : Boolean;
    procedure SetShowHints(Value : Boolean);

  public
    { Public declarations }
    procedure SetKey(Value : TLbKey);                                  {!!.08}
    procedure GetKey(var Value : TLbKey);                              {!!.08}

    property KeyType : TKeyType
      read FKeyType
      write FKeyType;

    property ShowHints : Boolean
      read GetShowHints
      write SetShowHints;
  end;


implementation

{$R *.fmx}

uses
  FMX.onguard1;

{ TEditProductFrm }

procedure TEditProductFrm.FormCreate(Sender: TObject);
begin
  InfoChanged(Sender);
end;

procedure TEditProductFrm.InfoChanged(Sender: TObject);
var
  Work : TLbKey;
begin
  OKBtn.Enabled := (Length(ProductEd.Text) > 0) and
    (HexToBuffer(KeyEd.Text, Work, SizeOf(Work)));
end;

procedure TEditProductFrm.KeyPasteSbClick(Sender: TObject);
begin
  KeyEd.PasteFromClipboard;
end;

procedure TEditProductFrm.GenerateKeySbClick(Sender: TObject);
var
  F    : TKeyGenerateFrm;
begin
  F := TKeyGenerateFrm.Create(Self);
  try
    F.SetKey(FKey);
    F.KeyType := FKeyType;
    if F.ShowModal = mrOK then begin
      F.GetKey(FKey);
      FKeyType := F.KeyType;
      KeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
      if HexStringIsZero(KeyEd.Text)then begin
        KeyEd.Text := '';
        FillChar(FKey, SizeOf(FKey), 0);
      end;

      InfoChanged(Sender);
    end;
  finally
    F.Free;
  end;
end;

function TEditProductFrm.GetShowHints : Boolean;
begin
  Result := False;
end;

procedure TEditProductFrm.SetShowHints(Value : Boolean);
begin
end;

procedure TEditProductFrm.GetKey(var Value : TLbKey);
begin
  Value := FKey;
end;

procedure TEditProductFrm.SetKey(Value : TLbKey);
begin
  FKey := Value;
end;

end.


