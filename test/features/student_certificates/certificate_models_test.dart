import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificates_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses complete certificate response safely', () {
    final response = CertificatesResponseModel.fromJson({
      'success': true,
      'length': '1',
      'data': [
        {
          '_id': 'id',
          'period': {'month': '7', 'year': 2026},
          'subjects': [
            {'maxScore': '20', 'score': 18},
          ],
          'percentage': '95',
          'issuedAt': '2026-07-20T16:49:36.609Z',
        },
      ],
    });

    expect(response.data.single.period.month, 7);
    expect(response.data.single.subjects.single.maxScore, 20);
    expect(response.data.single.percentage, 95);
    expect(response.data.single.issuedAt, isNotNull);
  });

  test('handles missing, null, invalid, and non-list data', () {
    expect(CertificatesResponseModel.fromJson(null).data, isEmpty);
    expect(
      CertificatesResponseModel.fromJson({'data': 'invalid'}).data,
      isEmpty,
    );
    final item = CertificatesResponseModel.fromJson({
      'data': [
        {
          'subjects': null,
          'issuedAt': 'invalid',
          'previewImagePath': '',
          'pdfPath': null,
        },
      ],
    }).data.single;
    expect(item.subjects, isEmpty);
    expect(item.issuedAt, isNull);
    expect(item.previewImagePath, isEmpty);
    expect(item.pdfPath, isEmpty);
  });

  test('accepts ideal supervisor type and supervisor recipient type', () {
    final item = CertificatesResponseModel.fromJson({
      'data': [
        {
          '_id': 'certificate-1',
          'certificateType': 'ideal_supervisor',
          'recipientType': 'supervisor',
        },
      ],
    }).data.single;
    expect(item.certificateType, 'ideal_supervisor');
    expect(item.id, 'certificate-1');
  });
}
