import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when clicking an active tab is to reset it to its root
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: navigationShell,
      floatingActionButton: navigationShell.currentIndex == 0 ? SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {
             // We need to access the Dashboard's action menu. 
             // Ideally, the FAB action should be lifted up or DashboardHome should handle it?
             // But FAB is on the Scaffold.
             // Best approach: Use a global event or Key?
             // Or simpler: Let the Home Tab handle its own FAB?
             // If we put FAB here, it's global. But the action menu implementation is in DashboardScreen.
             // Let's REMOVE FAB from here and let the Home Screen (First Tab) have its own Scaffold with FAB.
             // Wait, if Home has FAB, it might be covered by BottomBar? No, Scaffold handles it.
             // But BottomBar is HERE.
             // If BottomBar is here, FAB should normally be here for correct layout (docking).
             // However, triggering the specific modal from here requires access to logic.
             // Solution: Use a GlobalKey<DashboardScreenState> or notification?
             // Better: Move _showActionMenu logic to a shared widget or mixin we can call?
             // Hack: For now, let's LEAVE FAB NULL here and let the Home Tab (DashboardHome) provide it?
             // If inner Scaffold has FAB, it floats above content but might not dock with THIS bottom bar.
             // Let's try putting FAB in the child page first.
          },
          backgroundColor: const Color(0xFF9DF425),
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ) : null, // Logic needs to be dynamic. 
      // Actually, standard GoRouter shell often leaves Scaffolding to pages if FABs differ.
      // But the user wants BottomBar ALWAYS visible.
      // So this Scaffold MUST have the BottomBar.
      // If we want FAB to dock, it must be here.
      // For now, I will omit FAB here and let DashboardHome implement it. 
      // If it looks weird (not docked), we fix later.
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF141414),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF9DF425),
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          currentIndex: navigationShell.currentIndex,
          onTap: _goBranch,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Carteira',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Análise',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
