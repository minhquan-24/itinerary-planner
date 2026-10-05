import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS so Flutter app on Android Emulator can make HTTP requests
  app.enableCors();

  const port = 3000;
  await app.listen(port);
  console.log(`🚀 NestJS Backend đang chạy tại: http://localhost:${port}`);
  console.log(`📱 Android Emulator kết nối qua: http://10.0.2.2:${port}/api/trips`);
}
bootstrap();
