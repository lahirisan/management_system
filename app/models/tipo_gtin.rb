class TipoGtin < ActiveRecord::Base
 self.table_name = "tipo_gtin"  # El nombre de la tabla que se esta mapeando
 attr_accessible :tipo, :base, :habilitado
end
