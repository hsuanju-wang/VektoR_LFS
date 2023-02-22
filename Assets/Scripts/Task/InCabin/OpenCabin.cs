using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OpenCabin : Task
{
    public override void  StartTask()
    {
        base.StartTask();
        SceneManager.LoadScene("SpaceShip");
    }
}
