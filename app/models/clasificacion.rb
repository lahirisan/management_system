class Clasificacion < ActiveRecord::Base
  attr_accessible :categoria, :clase, :descripcion, :division, :grupo, :habilitado, :id
  self.table_name = "empresa_clasificacion"  # El nombre de la tabla que se esta mapeando

  def clasificacion # este metodo devuleve la descripcion de gtin y la base para mostrarlo en el formulario
    	"#{self.try(:categoria)}" + " " + "#{self.try(:division)}" + " " + "#{self.try(:grupo)}" + " " + "#{self.try(:clase)}" + "    " + "#{self.try(:descripcion)}"
 end


end
