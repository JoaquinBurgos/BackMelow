import React, { useState } from 'react';
import { Form, Select, Input, Button } from 'antd';

const AddNodeForm = ({ onSubmit, onCancel }) => {
  const [form] = Form.useForm();
  const [actionType, setActionType] = useState('');

  const handleActionTypeChange = (value) => {
    setActionType(value);
    form.resetFields(['subject', 'body', 'duration']); 
  };

  return (
    <Form form={form} layout="vertical" onFinish={onSubmit}>
      <Form.Item name="actionType" label="Action Type" rules={[{ required: true, message: 'Please, select a type of action' }]}>
        <Select onChange={handleActionTypeChange}>
          <Select.Option value="ActionEmail">Email Action</Select.Option>
          <Select.Option value="ActionWait">Wait Action</Select.Option>
        </Select>
      </Form.Item>

      {actionType === 'ActionEmail' && (
        <>
          <Form.Item name="subject" label="Subject" rules={[{ required: true, message: 'Please enter a subject' }]}>
            <Input />
          </Form.Item>
          <Form.Item name="body" label="Body" rules={[{ required: true, message: 'Please enter a body' }]}>
            <Input.TextArea />
          </Form.Item>
        </>
      )}

      {actionType === 'ActionWait' && (
        <Form.Item name="duration" label="Duration (minutes)" rules={[{ required: true, message: 'Please select a duration' }]}>
          <Input type="number" />
        </Form.Item>
      )}

      <Form.Item>
        <Button type="primary" style={{margin: "10px"}} htmlType="submit">Create Node</Button>
        <Button danger onClick={onCancel}>Cancel</Button>
      </Form.Item>
    </Form>
  );
};

export default AddNodeForm;
