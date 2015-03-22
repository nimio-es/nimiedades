object Inicio: TInicio
  Left = 260
  Top = 200
  Width = 526
  Height = 343
  Caption = 'Operaciones Diversas - V.0.99.13 (2.133-1)'
  Color = 16578037
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object statusBar: TStatusBar
    Left = 0
    Top = 270
    Width = 518
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 60
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 248
    Width = 518
    Height = 22
    Align = alBottom
    BevelOuter = bvNone
    Color = 16578037
    TabOrder = 1
    DesignSize = (
      518
      22)
    object Label1: TLabel
      Left = 424
      Top = 4
      Width = 37
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Opci'#243'n:'
    end
    object OpcionEdit: TMaskEdit
      Left = 468
      Top = 0
      Width = 25
      Height = 21
      Anchors = [akTop, akRight]
      EditMask = '99;0; '
      MaxLength = 2
      TabOrder = 0
      OnKeyPress = OpcionEditKeyPress
    end
  end
  object MainMenu1: TMainMenu
    Left = 468
    Top = 8
    object RegistrosMenu: TMenuItem
      Caption = 'Registros'
      object NuevoSubMenu: TMenuItem
        Caption = '&Nuevo'
        object Tipo01ItemMenu: TMenuItem
          Caption = 'Tipo 01 - Efectos (Cobros)'
        end
        object Tipo02ItemMenu: TMenuItem
          Caption = 'Tipo 02 - Cheques (Cobros)'
          OnClick = Tipo02ItemMenuClick
        end
        object Tipo03ItemMenu: TMenuItem
          Caption = 
            'Tipo 03 - Regularizaci'#243'n operaciones sistema intercambio car'#225'cte' +
            'r documental (Cobros/Pagos)'
          OnClick = Tipo03ItemMenuClick
        end
        object Tipo04ItemMenu: TMenuItem
          Caption = 
            'Tipo 04 - Regularizaci'#243'n operaciones sistema intercambio sin car' +
            #225'cter documental (Cobros/Pagos)'
        end
        object Tipo05ItemMenu: TMenuItem
          Caption = 'Tipo 05 - Actas de Protesto (Cobros)'
          OnClick = Tipo05ItemMenuClick
        end
        object Tipo06ItemMenu: TMenuItem
          Caption = 
            'Tipo 06 - Comisiones y Gastos de Cr'#233'ditos y/o Remesas documentar' +
            'ios (Cobros)'
          OnClick = Tipo06ItemMenuClick
        end
        object Tipo07ItemMenu: TMenuItem
          Caption = 'Tipo 07 - Pagos de Notar'#237'a (Pagos)'
          OnClick = Tipo07ItemMenuClick
        end
        object Tipo08ItemMenu: TMenuItem
          Caption = 'Tipo 08 - Cesiones de efectivo (Cobros)'
          OnClick = Tipo08ItemMenuClick
        end
        object Tipo09ItemMenu: TMenuItem
          Caption = 'Tipo 09 - Compraventa de moneda extranjera (Cobros/Pagos)'
          OnClick = Tipo09ItemMenuClick
        end
        object Tipo10ItemMenu: TMenuItem
          Caption = 'Tipo 10 - Reembolsos (Cobros/Pagos)'
          OnClick = Tipo10ItemMenuClick
        end
        object Tipo11ItemMenu: TMenuItem
          Caption = 'Tipo 11 - Regularizaci'#243'n desfases tesoreros (Cobros/Pagos)'
        end
        object Tipo12ItemMenu: TMenuItem
          Caption = 'Tipo 12 - Comisiones (Cobros)'
          OnClick = Tipo12ItemMenuClick
        end
        object Tipo13ItemMenu: TMenuItem
          Caption = 
            'Tipo 13 - Recuperaci'#243'n de comisiones y/o intereses de los Subsis' +
            'temas de Intercambio (Cobros)'
        end
        object Tipo14ItemMenu: TMenuItem
          Caption = 'Tipo 14 - Otras operaciones (Cobros/Pagos)'
          OnClick = Tipo14ItemMenuClick
        end
        object SepDevolucionesItemMenu: TMenuItem
          Caption = '-'
        end
        object DevolucionesItemMenu: TMenuItem
          Caption = 'Devoluciones'
          OnClick = DevolucionesItemMenuClick
        end
      end
      object LeerItemMenu: TMenuItem
        Caption = '&Leer'
        OnClick = LeerItemMenuClick
      end
      object EliminarItem: TMenuItem
        Caption = 'Eliminar'
        OnClick = EliminarItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SalirItemMenu: TMenuItem
        Caption = '&Salir'
        OnClick = SalirItemMenuClick
      end
    end
    object Utiles1: TMenuItem
      Caption = 'Utiles'
      object listMenuItem: TMenuItem
        Caption = 'Listado'
        OnClick = listMenuItemClick
      end
      object SoporteMenuItem: TMenuItem
        Caption = 'Soportes'
        OnClick = SoporteMenuItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mantenimientoMenuItem: TMenuItem
        Caption = 'Mantenimiento'
        object moverRegistrosViejosMenuItem: TMenuItem
          Caption = 'Mover registros viejos'
          OnClick = moverRegistrosViejosMenuItemClick
        end
        object RecuperarRegistrosMovidosMenuItem: TMenuItem
          Caption = 'Recuperar registros movidos'
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object configMenuItem: TMenuItem
        Caption = 'Configuraci'#243'n'
        OnClick = configMenuItemClick
      end
    end
  end
end
