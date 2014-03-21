require 'test_helper'

class EmpresasControllerTest < ActionController::TestCase
  setup do
    @empresa = empresas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:empresas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create empresa" do
    assert_difference('Empresa.count') do
      post :create, empresa: { cargo_rep_legal: @empresa.cargo_rep_legal, categoria: @empresa.categoria, clase: @empresa.clase, direccion_empresa: @empresa.direccion_empresa, division: @empresa.division, fecha_inscripcion: @empresa.fecha_inscripcion, grupo: @empresa.grupo, id_ciudad: @empresa.id_ciudad, id_clasificacion: @empresa.id_clasificacion, id_estado: @empresa.id_estado, id_status: @empresa.id_status, id_tipo_usuario: @empresa.id_tipo_usuario, nombre_comercial: @empresa.nombre_comercial, nombre_empresa: @empresa.nombre_empresa, rep_legal: @empresa.rep_legal, rif: @empresa.rif }
    end

    assert_redirected_to empresa_path(assigns(:empresa))
  end

  test "should show empresa" do
    get :show, id: @empresa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @empresa
    assert_response :success
  end

  test "should update empresa" do
    put :update, id: @empresa, empresa: { cargo_rep_legal: @empresa.cargo_rep_legal, categoria: @empresa.categoria, clase: @empresa.clase, direccion_empresa: @empresa.direccion_empresa, division: @empresa.division, fecha_inscripcion: @empresa.fecha_inscripcion, grupo: @empresa.grupo, id_ciudad: @empresa.id_ciudad, id_clasificacion: @empresa.id_clasificacion, id_estado: @empresa.id_estado, id_status: @empresa.id_status, id_tipo_usuario: @empresa.id_tipo_usuario, nombre_comercial: @empresa.nombre_comercial, nombre_empresa: @empresa.nombre_empresa, rep_legal: @empresa.rep_legal, rif: @empresa.rif }
    assert_redirected_to empresa_path(assigns(:empresa))
  end

  test "should destroy empresa" do
    assert_difference('Empresa.count', -1) do
      delete :destroy, id: @empresa
    end

    assert_redirected_to empresas_path
  end
end
