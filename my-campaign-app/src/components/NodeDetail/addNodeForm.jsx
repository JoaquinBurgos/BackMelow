// AddNodeForm.js
import React, { useState } from 'react';
import { Form, Select, Input, Button } from 'antd';

const AddNodeForm = ({ onSubmit }) => {
  const [form] = Form.useForm();
  const [actionType, setActionType] = useState('');

  const handleActionTypeChange = (value) => {
    setActionType(value);
    form.resetFields(['subject', 'body', 'duration']); // Específicamente resetea estos campos
  };

  return (
    <Form form={form} layout="vertical" onFinish={onSubmit}>
      <Form.Item name="actionType" label="Tipo de Acción" rules={[{ required: true, message: 'Por favor, selecciona un tipo de acción' }]}>
        <Select onChange={handleActionTypeChange}>
          <Select.Option value="ActionEmail">Email Action</Select.Option>
          <Select.Option value="ActionWait">Wait Action</Select.Option>
        </Select>
      </Form.Item>

      {actionType === 'ActionEmail' && (
        <>
          <Form.Item name="subject" label="Asunto" rules={[{ required: true, message: 'Por favor, ingresa un asunto' }]}>
            <Input />
          </Form.Item>
          <Form.Item name="body" label="Cuerpo del Email" rules={[{ required: true, message: 'Por favor, ingresa el cuerpo del email' }]}>
            <Input.TextArea />
          </Form.Item>
        </>
      )}

      {actionType === 'ActionWait' && (
        <Form.Item name="duration" label="Duración (segundos)" rules={[{ required: true, message: 'Por favor, ingresa la duración' }]}>
          <Input type="number" />
        </Form.Item>
      )}

      <Form.Item>
        <Button type="primary" htmlType="submit">Crear Nodo</Button>
      </Form.Item>
    </Form>
  );
};

export default AddNodeForm;
