-- Empresas
CREATE INDEX idx_empresas_tipo_empresa_id ON "Empresas" (tipo_empresa_id);
CREATE INDEX idx_empresas_estado_id ON "Empresas" (estado_id);
CREATE INDEX idx_empresas_cadastrado_por ON "Empresas" (cadastrado_por);
CREATE INDEX idx_empresas_alterado_por ON "Empresas" (alterado_por);

-- Produtos
CREATE INDEX idx_produtos_categoria_produto_id ON "Produtos" (categoria_produto_id);
CREATE INDEX idx_produtos_cadastrado_por ON "Produtos" (cadastrado_por);
CREATE INDEX idx_produtos_alterado_por ON "Produtos" (alterado_por);

-- Fornecedores_Produtos
CREATE INDEX idx_fornecedores_produtos_fornecedor_id ON "Fornecedores_Produtos" (fornecedor_id);
CREATE INDEX idx_fornecedores_produtos_produto_id ON "Fornecedores_Produtos" (produto_id);
CREATE INDEX idx_fornecedores_produtos_cadastrado_por ON "Fornecedores_Produtos" (cadastrado_por);
CREATE INDEX idx_fornecedores_produtos_alterado_por ON "Fornecedores_Produtos" (alterado_por);

-- Pedidos_Compra
CREATE INDEX idx_pedidos_compra_fornecedor_id ON "Pedidos_Compra" (fornecedor_id);
CREATE INDEX idx_pedidos_compra_enviado_por ON "Pedidos_Compra" (enviado_por);
CREATE INDEX idx_pedidos_compra_aprovado_por ON "Pedidos_Compra" (aprovado_por);
CREATE INDEX idx_pedidos_compra_status_pedido_compra_id ON "Pedidos_Compra" (status_pedido_compra_id);
CREATE INDEX idx_pedidos_compra_cadastrado_por ON "Pedidos_Compra" (cadastrado_por);
CREATE INDEX idx_pedidos_compra_alterado_por ON "Pedidos_Compra" (alterado_por);

-- Itens_Pedido_Compra
CREATE INDEX idx_itens_pedido_compra_pedido_compra_id ON "Itens_Pedido_Compra" (pedido_compra_id);
CREATE INDEX idx_itens_pedido_compra_produto_id ON "Itens_Pedido_Compra" (produto_id);
CREATE INDEX idx_itens_pedido_compra_cadastrado_por ON "Itens_Pedido_Compra" (cadastrado_por);
CREATE INDEX idx_itens_pedido_compra_alterado_por ON "Itens_Pedido_Compra" (alterado_por);

-- Pedidos
CREATE INDEX idx_pedidos_funcionario_id ON "Pedidos" (funcionario_id);
CREATE INDEX idx_pedidos_empresa_id ON "Pedidos" (empresa_id);
CREATE INDEX idx_pedidos_status_pedido_id ON "Pedidos" (status_pedido_id);
CREATE INDEX idx_pedidos_cadastrado_por ON "Pedidos" (cadastrado_por);
CREATE INDEX idx_pedidos_alterado_por ON "Pedidos" (alterado_por);

-- Itens_Pedido
CREATE INDEX idx_itens_pedido_pedido_id ON "Itens_Pedido" (pedido_id);
CREATE INDEX idx_itens_pedido_produto_id ON "Itens_Pedido" (produto_id);
CREATE INDEX idx_itens_pedido_status_pedido_id ON "Itens_Pedido" (status_pedido_id);
CREATE INDEX idx_itens_pedido_cadastrado_por ON "Itens_Pedido" (cadastrado_por);
CREATE INDEX idx_itens_pedido_alterado_por ON "Itens_Pedido" (alterado_por);

-- Inventario_Estoque
CREATE INDEX idx_inventario_estoque_produto_id ON "Inventario_Estoque" (produto_id);
CREATE INDEX idx_inventario_estoque_cadastrado_por ON "Inventario_Estoque" (cadastrado_por);
CREATE INDEX idx_inventario_estoque_alterado_por ON "Inventario_Estoque" (alterado_por);

-- Privilegios_Funcionarios
CREATE INDEX idx_privilegios_funcionarios_funcionario_id ON "Privilegios_Funcionarios" (funcionario_id);
CREATE INDEX idx_privilegios_funcionarios_privilegio_id ON "Privilegios_Funcionarios" (privilegio_id);

-- Funcionarios (auto relacionamento)
CREATE INDEX idx_funcionarios_cadastrado_por ON "Funcionarios" (cadastrado_por);
CREATE INDEX idx_funcionarios_alterado_por ON "Funcionarios" (alterado_por);