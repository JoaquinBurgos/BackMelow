import React from 'react';
import { Form, Input } from 'antd';

const PageVisitFields = () => (
  <Form.Item
    name="value"
    label="Ruta de la página"
    rules={[{ required: true, message: 'Por favor ingrese la ruta de la página!' }]}
  >
    <Input />
  </Form.Item>
);

export default PageVisitFields;
