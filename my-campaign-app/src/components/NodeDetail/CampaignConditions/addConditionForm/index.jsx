import React from 'react';
import { Modal, Form, Select, Button } from 'antd';
import LastLoginFields from './lastLoginFields';
import AccountCreationFields from './accountCreationFields';
import PageVisitFields from './pageVisitsFields';

const { Option } = Select;

const AddConditionForm = ({ open, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const handleOk = (values) => {
      console.log(values);
      form.resetFields();
      onCreate(values);
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
      cancelText="Cancelar"
      onCancel={onCancel}
      footer={null}
    >
      <Form form={form} layout="vertical" name="form_in_modal" onFinish={handleOk}>
        <Form.Item
          name="event_type"
          label="Condition Type"
          rules={[{ required: true, message: 'Please select a type of condition' }]}
        >
          <Select placeholder="Select a type" onChange={() => form.resetFields(['value'])}>
            <Option value="last_login">Last Login</Option>
            <Option value="account_creation">Client Created At</Option>
            <Option value="page_visit">Url Visited</Option>
          </Select>
        </Form.Item>
        <Form.Item shouldUpdate={(prevValues, currentValues) => prevValues.event_type !== currentValues.event_type}>
          {({ getFieldValue }) => renderConditionFields(getFieldValue('event_type'))}
        </Form.Item>
        <Form.Item>
        <Button type="primary" style={{margin: "10px"}} htmlType="submit">Create Node</Button>
        <Button danger onClick={onCancel}>Cancel</Button>
      </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddConditionForm;
