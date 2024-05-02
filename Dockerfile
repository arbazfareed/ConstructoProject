# Use the official Flutter image as a base
FROM cirrusci/flutter

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files
COPY pubspec.* ./

# Install dependencies
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the Flutter app for release
RUN flutter build apk --release

# Start the Flutter app
CMD ["flutter", "run", "--release"]

