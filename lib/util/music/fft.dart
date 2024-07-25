import 'dart:math';
import 'dart:typed_data';

class FFT {
  static List<Complex> fft(List<Complex> x) {
    int n = x.length;
    if (n <= 1) return x;

    List<Complex> even = fft(x.asMap().entries.where((entry) => entry.key % 2 == 0).map((entry) => entry.value).toList());
    List<Complex> odd = fft(x.asMap().entries.where((entry) => entry.key % 2 == 1).map((entry) => entry.value).toList());

    List<Complex> combined = List<Complex>.filled(n, Complex(0, 0));
    for (int k = 0; k < n / 2; k++) {
      double t = -2 * pi * k / n;
      Complex wk = Complex(cos(t), sin(t));
      combined[k] = even[k] + wk * odd[k];
      combined[k + n ~/ 2] = even[k] - wk * odd[k];
    }

    return combined;
  }

  static List<double> getFrequencyMagnitudes(Float64List audioData, int sampleRate) {
    int n = audioData.length;
    List<Complex> complex = audioData.map((x) => Complex(x, 0)).toList();
    List<Complex> fftResult = fft(complex);

    List<double> magnitudes = List<double>.filled(n ~/ 2, 0);
    for (int i = 0; i < n ~/ 2; i++) {
      magnitudes[i] = sqrt(fftResult[i].real * fftResult[i].real + fftResult[i].imag * fftResult[i].imag);
    }

    return magnitudes;
  }
}

class Complex {
  final double real;
  final double imag;

  Complex(this.real, this.imag);

  Complex operator +(Complex other) => Complex(real + other.real, imag + other.imag);
  Complex operator -(Complex other) => Complex(real - other.real, imag - other.imag);
  Complex operator *(Complex other) =>
      Complex(real * other.real - imag * other.imag, real * other.imag + imag * other.real);
}