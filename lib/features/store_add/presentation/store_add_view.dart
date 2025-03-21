import 'package:flutter/material.dart';

import '../../../widgets/custom_text_field.dart';

class StoreAddView extends StatefulWidget {
  const StoreAddView({super.key});

  @override
  State<StoreAddView> createState() => _StoreAddViewState();
}

class _StoreAddViewState extends State<StoreAddView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  /// 시
  final TextEditingController _cityController = TextEditingController();

  /// 군
  final TextEditingController _districtController = TextEditingController();

  /// 구
  final TextEditingController _neighborhoodController = TextEditingController();

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _rateOfPlanController = TextEditingController();
  final TextEditingController _specController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, top: 20, bottom: 20, right: 500),
      width: double.infinity * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'PC방 추가',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          CustomTextField(hintText: 'PC방 이름', controller: _nameController),
          SizedBox(height: 20),

          Row(
            children: [
              CustomTextField(hintText: '주소', controller: _addressController),
              SizedBox(width: 20),
              _buttonItem('주소 검색', Colors.purpleAccent),
            ],
          ),
          SizedBox(height: 20),

          Row(
            children: [
              CustomTextField(
                isSubAddress: true,
                hintText: 'AA시',
                controller: _cityController,
              ),
              SizedBox(width: 10),
              CustomTextField(
                isSubAddress: true,
                hintText: 'BB구',
                controller: _districtController,
              ),
              SizedBox(width: 10),
              CustomTextField(
                isSubAddress: true,
                hintText: 'CC동',
                controller: _neighborhoodController,
              ),
            ],
          ),
          SizedBox(height: 20),

          CustomTextField(hintText: 'IP', controller: _ipController),
          SizedBox(height: 20),
          CustomTextField(hintText: 'Port', controller: _portController),
          SizedBox(height: 20),
          CustomTextField(hintText: '좌석 수', controller: _seatController),
          SizedBox(height: 20),
          CustomTextField(hintText: '요금제 가격', controller: _priceController),
          SizedBox(height: 20),
          CustomTextField(
            hintText: 'PC 요금제 비율',
            controller: _rateOfPlanController,
          ),
          SizedBox(height: 20),
          CustomTextField(hintText: 'PC 사양', controller: _specController),
          SizedBox(height: 20),
          CustomTextField(hintText: '통신사', controller: _agencyController),
          SizedBox(height: 20),
          CustomTextField(hintText: '메모', controller: _memoController),
          SizedBox(height: 20),

          _bottomRowBtn(),
        ],
      ),
    );
  }

  Widget _bottomRowBtn() {
    return Row(
      children: [
        _buttonItem('추가', Colors.purpleAccent),
        SizedBox(width: 20),
        _buttonItem('취소', Colors.grey),
      ],
    );
  }

  Widget _buttonItem(String text, Color color) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
