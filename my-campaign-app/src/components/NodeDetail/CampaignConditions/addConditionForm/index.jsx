import React from 'react';
import { Modal, Form, Select } from 'antd';
import LastLoginFields from './lastLoginFields';
import AccountCreationFields from './accountCreationFields';
import PageVisitFields from './pageVisitsFields';

const { Option } = Select;

const AddConditionForm = ({ open, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const handleOk = () => {
    form.validateFields().then(values => {
      form.resetFields();
      onCreate(values);
    });
  };

  const renderConditionFields = (eventType) => {
    switch (eventType) {
      case 'last_login':
        return <LastLoginFields />;
      case 'account_creation':
        return <AccountCreationFields />;
      case 'page_visit':
        return <PageVisitFields />;
      default:
        return null;
    }
  };

  return (
    <Modal
      open={open}
      title="Agregar nueva condición"
      okText="Crear"
      cancelText="Cancelar"
      onCancel={onCancel}
      onOk={handleOk}
    >
      <Form form={form} layout="vertical" name="form_in_modal">
        <Form.Item
          name="event_type"
          label="Tipo de Condición"
          rules={[{ required: true, message: 'Por favor, seleccione el tipo de condición!' }]}
        >
          <Select placeholder="Seleccione un tipo" onChange={() => form.resetFields(['value'])}>
            <Option value="last_login">Último login</Option>
            <Option value="account_creation">Fecha de creación del cliente</Option>
            <Option value="page_visit">Visita a página</Option>
          </Select>
        </Form.Item>
        <Form.Item shouldUpdate={(prevValues, currentValues) => prevValues.event_type !== currentValues.event_type}>
          {({ getFieldValue }) => renderConditionFields(getFieldValue('event_type'))}
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddConditionForm;
