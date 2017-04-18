function image = imunpack(message)
  compressedImage = com.labviros.is.msgs.camera.CompressedImage(message);
  stream = java.io.ByteArrayInputStream(compressedImage.getData());
  buffer = javax.imageio.ImageIO.read(stream);
  data = buffer.getData().getPixels(0, 0, buffer.getWidth(), buffer.getHeight(), []);
  image = uint8(permute(reshape(data, 3, buffer.getWidth(), buffer.getHeight()), [3, 2, 1]));  
end