import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/modules/normal/login/user_info_model.dart';
import 'package:last/modules/admin/widgets/admin_drawer.dart';
import 'package:last/modules/admin/user_management/user_management_view_model.dart';
import 'package:last/modules/admin/widgets/filter_search_bar.dart';
import 'package:last/modules/admin/user_management/widgets/user_management_table_cell.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late UserManagementViewModel _viewModel;
  late TextEditingController _searchTextEditingController;
  final Map<int, TableColumnWidth> _tableColumnWidth =
      const <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.3),
    2: FlexColumnWidth(0.5),
    3: FlexColumnWidth(0.2),
    4: FlexColumnWidth(0.2),
    5: FlexColumnWidth(0.1),
    // 6: FlexColumnWidth(0.1),
  };
  final double _tableHeaderPadding = 20;

  @override
  void initState() {
    super.initState();
    _viewModel = UserManagementViewModel();
    _searchTextEditingController = TextEditingController();
    _viewModel.getUseInfoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(
          currentIndex: MainPageIndexConstants.userManagementIndex),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        // title: const Center(child: Text("ฟังก์ชันสำหรับผู้ดูแลระบบ")),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            _header(),
            _table(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          child: Text(
            "จัดการผู้ใช้งาน",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 42,
              // color: kPrimaryDarkColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: _searchBar(),
        ),
      ],
    );
  }

  Widget _searchBar() {
    void onSearchTextChanged({required String searchText}) {
      setState(() {
        // onUserSearchShopGroup(searchText);
      });
    }

    return SizedBox(
      // width: _screenWidth * 0.3,
      height: 35,
      child: FilterSearchBar(
        onSearch: onSearchTextChanged,
        searchTextEditingController: _searchTextEditingController,
        labelText: '',
      ),
    );
  }

  Widget _table() {
    return Expanded(
      child: Column(
        children: [
          _tableHeader(),
          _tableBody(),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Table(
      columnWidths: _tableColumnWidth,
      border: TableBorder.symmetric(
        inside: const BorderSide(
          width: 1,
          // color: primary,
        ),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: primary,
            border: Border.all(
              width: 1,
              // color: primary,
            ),
            // color: kColorLightBlueBTN,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: const Center(
                  child: Text(
                    'ลำดับที่',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: const Center(
                  child: Text(
                    'รหัสผู้ใช้งาน',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: const Center(
                  child: Text(
                    'ชื่อ',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            // TableCell(
            //   child: Padding(
            //     padding: EdgeInsets.all(8),
            //     child: Center(
            //       child: Text(
            //         'รหัสผู้ใช้งาน',
            //         style: TextStyle(fontSize: 17),
            //       ),
            //     ),
            //   ),
            // ),
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'User Management Admin',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Pet Food Management Admin',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            const TableCell(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableBody() {
    // void onShopGroupRemove(String shopGroupID) {
    //   setState(() {
    //     onUserDeleteShopGroup(shopGroupID);
    //   });
    // }

    void onUserRemove({required String userID}) {
      setState(() {
        // onUserDeleteShopGroup(index);
      });
    }

    return Expanded(
        child: FutureBuilder<List<UserInfoModel>>(
            future: _viewModel.userInfoListData,
            builder: (context, AsyncSnapshot<List<UserInfoModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _loadingScreen();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.9,
                        color: lightGrey,
                      ),
                      left: BorderSide(
                        width: 0.9,
                        color: lightGrey,
                      ),
                      right: BorderSide(
                        width: 0.9,
                        color: lightGrey,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _viewModel.filterUserInfoList.length,
                    itemBuilder: (context, index) {
                      return UserManagementTableCell(
                        index: index,
                        viewModel: _viewModel,
                        shopGroupRemoveCallBack: onUserRemove,
                        context: context,
                        tableColumnWidth: _tableColumnWidth,
                      );
                    },
                  ),
                );
              }

              return const Text('No data available');
            }));
  }

  Widget _loadingScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "กำลังโหลดข้อมูล กรุณารอสักครู่...",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
