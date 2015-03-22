inherited OpDivRecType08Form: TOpDivRecType08Form
  Left = 254
  Top = 215
  Width = 640
  Height = 377
  Caption = '08 - Cesiones de efectivo'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 302
    Width = 632
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 76
    Top = 192
  end
  inherited ReferencePanel: TPanel
    Width = 632
    TabOrder = 12
    inherited OpNatPanel: TPanel
      Width = 150
    end
    inherited DateCreationPanel: TPanel
      Left = 471
    end
  end
  inherited bottomPanel: TPanel
    Top = 315
    Width = 632
    TabOrder = 13
    inherited AceptarButton: TButton
      Left = 471
    end
    inherited CancelarButton: TButton
      Left = 551
    end
  end
  inherited cobroRadioBtn: TRadioButton
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 140
    Top = 268
    TabOrder = 11
  end
  inherited observacionesMemo: TMemo
    Top = 192
    TabOrder = 10
  end
end
