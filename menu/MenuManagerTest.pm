package MenuManagerTest;
use strict;
use warnings;
use base 'TestCase';

use MenuManager;


sub test_return_true_on_addmenu
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu", url => 'abc' };
    $self->assert_num_equals(1, $manager->addMenu("My menu", [$submenu]));
}

sub test_return_complete_menu
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu", url => 'abc' };
    my $menu_title = "My menu";
    $manager->addMenu($menu_title, [$submenu]);

    $self->assert_deep_equals(
        [
            {
                title   => $menu_title,
                url     => '',
                submenu => [$submenu]
            }
        ],
        [$manager->getMenu()]
    );
}

sub test_add_menu_after
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $url = 'abc';
    my $submenu = { title => "Submenu1", url => $url };
    my $submenu2 = { title => "Submenu2", url => $url };
    my $menu_title = "My menu1";
    my $menu_title_2 = "My menu2";
    $manager->addMenu($menu_title, [$submenu]);
    $manager->addMenu($menu_title_2, [$submenu2]);

    my $menu_title_3 = "My menu3";
    my $submenu3 = { title => "Submenu3", url => $url };
    $manager->addMenuAfter($menu_title, $menu_title_3, [$submenu3]);

    $self->assert_deep_equals(
        [
            {
                title => $menu_title,
                url => '',
                submenu => [$submenu]
            },
            {
                title => $menu_title_3,
                url => '',
                submenu => [$submenu3]
            },
            {
                title => $menu_title_2,
                url => '',
                submenu => [$submenu2]
            }
        ],
        [$manager->getMenu()]
    );
}

sub test_add_menu_before
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu1", url => 'abc' };
    my $submenu2 = { title => "Submenu2", url => 'abc' };
    my $menu_title = "My menu1";
    my $menu_title_2 = "My menu2";
    $manager->addMenu($menu_title, [$submenu]);
    $manager->addMenu($menu_title_2, [$submenu2]);

    my $submenu3 = { title => "Submenu3", url => 'abc' };
    my $menu_title_3 = "My menu3";
    $manager->addMenuBefore($menu_title, $menu_title_3, [$submenu3]);

    $self->assert_deep_equals(
        [
            {
                title => $menu_title_3,
                url => '',
                submenu => [$submenu3]
            },
            {
                title => $menu_title,
                url => '',
                submenu => [$submenu]
            },
            {
                title => $menu_title_2,
                url => '',
                submenu => [$submenu2]
            }
        ],
        [$manager->getMenu()]
    );
}

sub test_add_sub_menu_before
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu1", url => 'abc1' };
    my $submenu_title_2 = "Submenu2";
    my $submenu2 = { title => $submenu_title_2, url => 'abc2' };
    my $menu_title = "My menu";
    $manager->addMenu($menu_title, [$submenu, $submenu2]);

    my $submenu3 = { title => "Submenu3", url => 'abc3' };
    $manager->addSubmenuBefore($menu_title, $submenu_title_2, $submenu3);

    $self->assert_deep_equals(
        [
            {
                title => $menu_title,
                url => '',
                submenu => [$submenu, $submenu3, $submenu2]
            }
        ],
        [$manager->getMenu()]
    );
}

sub test_add_sub_menu_after
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu_title = "Submenu1";
    my $submenu = { title => $submenu_title, url => 'abc1' };
    my $submenu2 = { title => "Submenu2", url => 'abc2' };
    my $menu_title = "My menu";
    $manager->addMenu($menu_title, [$submenu,$submenu2]
    );

    my $submenu3 = { title => "Submenu3", url => 'abc3' };
    $manager->addSubmenuAfter($menu_title, $submenu_title, $submenu3);

    $self->assert_deep_equals(
        [
            {
                title => $menu_title,
                url => '',
                submenu => [$submenu, $submenu3, $submenu2]
            }
        ],
        [$manager->getMenu()]
    );
}

sub test_throw_on_unknown_anchor_for_addmenu
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu3", url => 'abc' };
    $self->assert_raises_matches(
        'Error::Simple',
        sub
        {
            $manager->addMenuBefore("Some unknown menu", "My menu3", [$submenu])
        },
        qr/Anchor menu not found/
    );
}

sub test_throw_on_unknown_anchor_for_addsubmenu
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu3", url => 'abc' };
    $self->assert_raises_matches(
        'Error::Simple',
        sub
        {
            $manager->addSubmenuBefore("Some unknown menu", "Some unknown submenu", $submenu)
        },
        qr/Anchor menu not found/
    );
}

sub test_throw_on_unknown_subanchor_for_addsubmenu
{
    my $self = shift;

    my $manager = _buildMenuManager();

    my $submenu = { title => "Submenu1", url => 'abc1' };
    my $menu_title = "My menu";
    $manager->addMenu($menu_title, [$submenu]);

    my $submenu3 = { title => "Submenu3", url => 'abc' };
    $self->assert_raises_matches(
        'Error::Simple',
        sub
        {
            $manager->addSubmenuBefore($menu_title, "Some unknown submenu", $submenu3)
        },
        qr/Anchor submenu not found/
    );
}

sub _buildMenuManager
{
    return MenuManager->new(@_);
}

1;
