class TipoGtin < ActiveRecord::Base
 self.table_name = "tipo_gtin"  # El nombre de la tabla que se esta mapeando
 attr_accessible :tipo, :base, :habilitado

 
	def tipo_gtin_base # este metodo devuleve la descripcion de gtin y la base para mostrarlo en el formulario
    	"#{self.tipo}" + " " + "#{self.base}"
 	end

end
