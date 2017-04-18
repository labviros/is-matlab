
% Before calling this function you should add the jar file by executing:
%
% >> javaaddpath('./is.jar');

function [] = frameconsumer()
  connection = com.labviros.is.Connection('amqp://192.168.1.110');
  queue = connection.subscribe('data', 'ptgrey.0.frame'); 
  
  clean = onCleanup(@() cleanup(connection));

  % Create sampling rate request message 
  rate = com.labviros.is.msgs.common.SamplingRate; 
  rate.setPeriod(100); % ms

  % Send 'set_sample_rate' request to camera 'ptgrey.0'
  id = connection.client().request('ptgrey.0.set_sample_rate', rate);

  % Wait reply with 1s timeout
  reply = connection.client().receiveDiscardOthers(id, 1, java.util.concurrent.TimeUnit.SECONDS);

  if reply == []
    display('Request timeout');
    return;
  end

  % Unpack status and check if call was successful 
  status = com.labviros.is.msgs.common.Status(reply);
  if status.getValue() ~= 'ok' 
    display('Request failed');
    return;
  end

  for i = 1:100
    message = queue.take(); % Wait forever waiting a message from 'ptgrey.0.frame'
    image = imunpack(message); % unpack message to image matrix
    % ... 
  end
end

function [] = cleanup(connection)
  display('Cleaning...')
  connection.unsubscribe('data', 'ptgrey.0.frame');
  connection.stop();
end